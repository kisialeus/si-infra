resource "kubernetes_namespace" "simplesurance" {
  metadata {
    annotations = {
      name = "simplesurance"
    }

    labels = {
      argocd        = "true"
      simplesurance = "true"
    }

    name = "simplesurance"
  }
}

resource "kubernetes_manifest" "argocd_project_simplesurance" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata   = {
      name       = "simplesurance"
      namespace  = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      description = "Test task simplesurance"
      sourceRepos = ["*"]

      destinations = [
        {
          namespace = "si*"
          server    = "https://kubernetes.default.svc"
          name      = "in-cluster"
        }
      ]

      clusterResourceWhitelist = [
        {
          group = "*"
          kind  = "*"
        }
      ]
    }
  }
}
