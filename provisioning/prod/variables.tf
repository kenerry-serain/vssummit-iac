
variable "ec2_control_plane_launch_template_name" {
  default = "launch-template-control-plane-prod-vssummit"
}

variable "ec2_instance_type" {
  default = "t2.medium"
}

variable "ec2_worker_launch_template_name" {
  default = "launch-template-worker-prod-vssummit"
}

variable "tags" {
  type = object({
    Project     = string,
    Environment = string
  })
  default = {
    Project     = "VsSummit"
    Environment = "PRD"
  }
}

variable "ecr_repositories" {
  type = list(string)
  default = [
    "ecommerce/production/stock-api",
    "ecommerce/production/gateway-api",
    "ecommerce/production/healthcheck-api",
    "ecommerce/production/order-api",
    "ecommerce/production/principal-api",
  ]
}


variable "control_plane_autoscaling_group" {
  type = object({
    name : string,
    min_size : number,
    max_size : number,
    desired_capacity : number,
  })

  default = {
    name : "control-plane-auto-scaling-group-prod-vssummit"
    min_size         = 1,
    max_size         = 1,
    desired_capacity = 1,
  }
}

variable "worker_autoscaling_group" {
  type = object({
    name : string,
    min_size : number,
    max_size : number,
    desired_capacity : number,
  })

  default = {
    name : "worker-auto-scaling-group-prod-vssummit"
    min_size         = 1,
    max_size         = 1,
    desired_capacity = 1,
  }
}

variable "vpc" {
  type = object({
    name       = string,
    cidr_block = string
    subnets = list(object({
      name                       = string,
      cidr_block                 = string,
      should_be_public_available = bool,
      availability_zone          = string
    }))
  })

  default = {
    name : "vpc-prod-vssummit",
    cidr_block : "10.0.0.0/16"
    subnets : [
      {
        name : "vpc-prod-public-subnet-1a",
        cidr_block : "10.0.1.0/24",
        should_be_public_available : true,
        availability_zone : "us-east-1a"
      },
      {
        name : "vpc-prod-public-subnet-1b",
        cidr_block : "10.0.2.0/24",
        should_be_public_available : true,
        availability_zone : "us-east-1b"
      }]
  }
}
