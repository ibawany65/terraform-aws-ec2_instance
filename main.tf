## Get AMI
# data "aws_ami" "default" {
#   owners             = var.ami_owners
#   most_recent        = var.most_recent_ami
#   executable_users   = var.ami_executable_users
#   include_deprecated = var.include_deprecated_ami
#   name_regex         = var.ami_name_regex

#   dynamic "filter" {
#     for_each = var.ami_filter != null ? [true] : []

#     content {
#       name   = ami_filter.name
#       values = ami_filter.values
#     }
#   }
# }

## Get VPC data
data "aws_vpc" "current" {
  provider = aws.network
  
  tags = {
    "aws:cloudformation:stack-name" = var.vpc_name
  }
}

## Get Subnets from VPC
data "aws_subnets" "vpc" {
  provider = aws.network
  
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }
}

## Get private key
data "aws_secretsmanager_secret" "private_key" {
  arn = var.arn
}

data "aws_secretsmanager_secret_version" "private_key" {
  secret_id = data.aws_secretsmanager_secret.private_key.id
}

## EC2 Instance
resource "aws_instance" "default" {
  ami                                  = "ami-05ac86c9b78839ecc" #data.aws_ami.default.id
  associate_public_ip_address          = var.associate_public_ip_address
  availability_zone                    = var.availability_zone
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
  disable_api_stop                     = var.disable_api_stop
  disable_api_termination              = var.disable_api_termination
  ebs_optimized                        = var.enable_ebs_optimization
  get_password_data                    = var.get_password_data
  hibernation                          = var.enable_hibernation_support
  host_id                              = var.host_id
  host_resource_group_arn              = var.host_resource_group_arn
  iam_instance_profile                 = var.iam_instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.launch_template != null ? null : var.instance_type
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  key_name                             = var.key_name
  monitoring                           = var.enable_instance_monitoring
  placement_group                      = var.placement_group
  placement_partition_number           = var.placement_partition_number
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  source_dest_check                    = var.source_dest_check
  subnet_id                            = element(data.aws_subnets.vpc.ids, 0)
  tenancy                              = var.tenancy
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  user_data_replace_on_change          = var.user_data_replace_on_change
  volume_tags                          = var.enable_volume_tags ? var.tags : {}
  vpc_security_group_ids               = var.vpc_security_group_ids

  tags = merge(
    var.tags,
    {
      service = var.service_name
      Name    = lower(join("-", compact(["${var.env_type}${var.env_name}${lookup(var.region_short, var.region)}", var.app_name, var.service_name, var.ordinal != 0 ? format("%02d", var.ordinal) : ""])))
    }
  )

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []

    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)

      dynamic "capacity_reservation_target" {
        for_each = capacity_reservation_specification.value.capacity_reservation_target != null ? [capacity_reservation_specification.value.capacity_reservation_target] : []
        
        content{
        capacity_reservation_id                 = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        capacity_reservation_resource_group_arn = lookup(capacity_reservation_target.value, "capacity_reservation_resource_group_arn", null)
        }
      }
    }
  }

  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []

    content {
      cpu_credits = lookup(credit_specification.value, "cpu_credits", null)
    }
  }

  dynamic "enclave_options" {
    for_each = var.enclave_options != null ? [var.enclave_options] : []

    content {
      enabled = lookup(enclave_options.value, "enabled", false)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device != null ? [var.ephemeral_block_device] : []

    content {
      device_name  = ephemeral_block_device.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []

    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  dynamic "maintenance_options" {
    for_each = var.maintenance_options != null ? [var.maintenance_options] : []

    content {
      auto_recovery = lookup(maintenance_options.value, "enable_auto_recovery", null)
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []

    content {
      http_endpoint               = lookup(metadata_options.value, "enable_http_endpoint", null)
      instance_metadata_tags      = lookup(metadata_options.value, "enable_metadata_tags", null)
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", null)
      http_tokens                 = lookup(metadata_options.value, "http_tokens", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface_settings != null ? [var.network_interface_settings] : []

    content {
      delete_on_termination = false ## Currently, only a false value is supported with Terraform
      device_index          = network_interface_settings.device_index
      network_card_index    = lookup(network_interface_settings.value, "network_card_index", null)
      network_interface_id  = network_interface_settings.network_interface_id
    }
  }

  dynamic "private_dns_name_options" {
    for_each = var.private_dns_name_options != null ? [var.private_dns_name_options] : []

    content {
      enable_resource_name_dns_a_record    = lookup(private_dns_name_options.value, "enable_resource_name_dns_a_record", null)
      enable_resource_name_dns_aaaa_record = lookup(private_dns_name_options.value, "enable_resource_name_dns_aaaa_record", null)
      hostname_type                        = lookup(private_dns_name_options.value, "hostname_type", null)
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device_settings != null ? [var.root_block_device_settings] : []

    content {
      volume_type           = lookup(root_block_device_settings.value, "volume_type", null)
      volume_size           = lookup(root_block_device_settings.value, "volume_size", null)
      iops                  = root_block_device_settings.volume_type == "io1" || root_block_device_settings.volume_type == "io2" || root_block_device_settings.volume_type == "gp3" ? lookup(root_block_device_settings.value, "iops", null) : null
      throughput            = root_block_device_settings.volume_type == "gp3" ? lookup(root_block_device_settings.value, "throughput", null) : null
      delete_on_termination = lookup(root_block_device_settings.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device_settings.value, "enable_encryption", null)
      kms_key_id            = lookup(root_block_device_settings.value, "kms_key_id", null)
    }
  }
  
  /*
  # ## Add PK to instance
  # provisioner "remote-exec" {
  #   inline = ["echo ${data.aws_secretsmanager_secret_version.private_key.secret_string} > private-key.pem"]

  #   connection {
  #     type        = "ssh"
  #     private_key = data.aws_secretsmanager_secret_version.private_key.secret_string
  #   }
  # }

  # ## Pull PK and run destroy script
  # provisioner "remote-exec" {
  #   when   = destroy
  #   inline = ["realm leave"]

  #   connection {
  #     type        = "ssh"
  #     private_key = file("private-key.pem")
  #   }
  # }
  */
  
  }
