resource "kubernetes_service_account" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.project_prefix}-${var.environment}-external-dns-irsa-role"
    }

    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"

    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods", "nodes"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "watch", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns_viewer" {
  metadata {
    name = "external-dns-viewer"

    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata[0].name
    namespace = kubernetes_service_account.external_dns.metadata[0].namespace
  }
}


resource "kubernetes_deployment" "external_dns" {
  metadata {
    name      = "external-dns"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "external-dns"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "external-dns"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata[0].name

        container {
          name  = "external-dns"
          image = "k8s.gcr.io/external-dns/external-dns:${var.versions.external_dns}"
          args = [
            "--source=service",
            "--source=ingress",
            "--domain-filter=${var.domain_name}",
            "--provider=aws",
            "--policy=sync",
            "--aws-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=external-dns"
          ]

          env {
            name  = "AWS_DEFAULT_REGION"
            value = var.aws_region
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "200Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
        }
      }
    }
  }
}
