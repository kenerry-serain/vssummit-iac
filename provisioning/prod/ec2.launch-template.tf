data "aws_ami" "debian" {
  filter {
    name   = "name"
    values = ["debian-11-amd64-20220503-998"]
  }
}


resource "aws_launch_template" "control_plane_launch_template" {
  name                    = var.ec2_control_plane_launch_template_name
  image_id                = data.aws_ami.debian.id
  instance_type           = var.ec2_instance_type
  key_name                = aws_key_pair.generated_key.key_name
  vpc_security_group_ids  = [aws_security_group.web_access.id]
  disable_api_stop        = true
  disable_api_termination = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = false
      volume_size           = 30
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  depends_on = [
    aws_iam_role.role
  ]
}

resource "aws_launch_template" "worker_launch_template" {
  name                    = var.ec2_worker_launch_template_name
  image_id                = data.aws_ami.debian.id
  instance_type           = var.ec2_instance_type
  key_name                = aws_key_pair.generated_key.key_name
  vpc_security_group_ids  = [aws_security_group.web_access.id]
  disable_api_stop        = true
  disable_api_termination = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = false
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }

  depends_on = [
    aws_iam_role.role
  ]
}

