locals {
  common_tags = [
    {
      key                 = "Project",
      value               = "VsSummit",
      propagate_at_launch = true
    },
    {
      key                 = "Environment",
      value               = "PRD",
      propagate_at_launch = true

    },
    {
      key                 = "kubernetes.io/cluster/vssummit-ecommerceprod",
      value               = "shared",
      propagate_at_launch = true
    },
    {
      key                 = "kubernetes.io/role/internal-elb",
      value               = "1",
      propagate_at_launch = true
    }
  ]

  acg_control_plane_tags = concat(local.common_tags, [{
    key                 = "Name",
    value               = "vssummit-ecommerce-prod-master",
    propagate_at_launch = true
    }
  ])

  acg_worker_tags = concat(local.common_tags, [{
    key                 = "Name",
    value               = "vssummit-ecommerce-prod-worker",
    propagate_at_launch = true
  }])
}
resource "aws_autoscaling_group" "control_plane_autoscaling_group" {
  name                      = var.control_plane_autoscaling_group.name
  min_size                  = var.control_plane_autoscaling_group.min_size
  max_size                  = var.control_plane_autoscaling_group.max_size
  desired_capacity          = var.control_plane_autoscaling_group.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = [for subnet in aws_subnet.subnets : subnet if subnet.map_public_ip_on_launch == true].*.id
  protect_from_scale_in     = true
  tags                      = local.acg_control_plane_tags

  launch_template {
    id      = aws_launch_template.control_plane_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "worker_autoscaling_group" {
  name                      = var.worker_autoscaling_group.name
  min_size                  = var.worker_autoscaling_group.min_size
  max_size                  = var.worker_autoscaling_group.max_size
  desired_capacity          = var.worker_autoscaling_group.desired_capacity
  health_check_type         = "EC2"
  health_check_grace_period = 300
  vpc_zone_identifier       = [for subnet in aws_subnet.subnets : subnet if subnet.map_public_ip_on_launch == true].*.id
  protect_from_scale_in     = true
  tags                      = local.acg_worker_tags

  launch_template {
    id      = aws_launch_template.worker_launch_template.id
    version = "$Latest"
  }
}
