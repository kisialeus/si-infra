resource "kubernetes_namespace" "argocd" {
  metadata {
    annotations = {
      name = "argocd"
    }

    labels = {
      argocd = "true"
    }

    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name = "argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].annotations.name
  version    = var.versions.argo_cd

}

#TODO !!!! WE NEED to patch argocd cm to allow http (ssl termination will be in LB) :(
resource "kubernetes_ingress_v1" "argocd_ingress" {
  metadata {
    name        = "argocd-ingress"
    namespace   = "argocd"
    annotations = {
      "kubernetes.io/ingress.class"                    = "alb"
      "alb.ingress.kubernetes.io/target-type"          = "ip"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/certificate-arn"      = aws_acm_certificate.argocd_cert.arn
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "argocd.${var.domain_name}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "argocd-server"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    helm_release.argocd,
    helm_release.argocd_image_updater,
    helm_release.aws_load_balancer_controller
  ]
}


resource "helm_release" "argocd_image_updater" {
  name       = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  namespace  = kubernetes_namespace.argocd.metadata[0].annotations.name
  version    = var.versions.argo_cd_image_updater
  values     = [
    templatefile("${path.module}/helm-values/argocd-image-updater.yaml.tpl", {
      account_id = data.aws_caller_identity.current.account_id
      role_arn   = var.role_arns.argocd_image_updater_irsa_role
      region = var.aws_region
    })
  ]
}
