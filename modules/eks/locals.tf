data "aws_caller_identity" "current" {}


locals {
  account_id = data.aws_caller_identity.current.account_id
  eks_nodegroups = {
    for nodegroup in var.eks_nodegroups : nodegroup.name => {
      min_size     = nodegroup.min_size
      max_size     = nodegroup.max_size
      desired_size = nodegroup.desired_size

      update_config = {
        max_unavailable_percentage = 50
      }
      force_update_version    = true
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true

      instance_types = nodegroup.instance_types != null ? nodegroup.instance_types : null
      capacity_type  = nodegroup.is_spot ? "SPOT" : null

      subnet_ids =  var.private_subnets

      ami_type = nodegroup.ami_type != null ? nodegroup.ami_type : null

      block_device_mappings = nodegroup.volume_size != null ? {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = nodegroup.volume_size
            volume_type           = nodegroup.volume_type
            iops                  = 3000
            throughput            = 150
            delete_on_termination = nodegroup.delete_volume_on_termination
          }
        }
      } : {}

      labels = {
        compute-type = "ec2"
        env = var.environment
        env = nodegroup.custom_label != null ? "${var.environment}-${nodegroup.custom_label}" : var.environment
        type = nodegroup.type
        capacity_type = nodegroup.is_spot ? "spot" : "ondemand"

      }
    }
  }
}
