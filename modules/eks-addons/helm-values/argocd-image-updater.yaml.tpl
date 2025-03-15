config:
  registries:
  - name: ECR
    api_url: https://${account_id}.dkr.ecr.${region}.amazonaws.com
    prefix: ${account_id}.dkr.ecr.${region}.amazonaws.com
    default: true
    ping: yes
    insecure: no
    credentials: ext:/scripts/ecr-login.sh
    credsexpire: 11h

# https://github.com/argoproj-labs/argocd-image-updater/issues/720
authScripts:
  enabled: true
  scripts:
    ecr-login.sh: |
      #!/bin/sh
      HOME=/tmp aws ecr --region $AWS_REGION get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -d

serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
  name: "argocd-image-updater"
