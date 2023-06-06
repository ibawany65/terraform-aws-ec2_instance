variable "ami_executable_users" {
  description = "Limits the search to users with explicit launch permission on the image."
  type        = list(string)
  default     = ["self"]
}

variable "ami_name_regex" {
  description = "The regex string to apply to the AMI list returned by AWS. This allows more advanced filtering not supported from the AWS API."
  type        = string
  default     = null
}

variable "ami_filter" {
  description = "One or more name/value pairs to filter off of."
  type = object({
    name   = string
    values = list(string)
  })
  default = null
}

variable "ami_owners" {
  description = "A list of AMI owners to limit the search."
  type        = list(string)
  default     = null
}

variable "app_name" {
  description = "A 6 character name assigned for the application."
  type        = string

  validation {
    condition     = length(var.app_name) == 6
    error_message = "Value must be exactly 6 characters."
  }
}

variable "arn" {
  description = "The ARN of the private key secret in Secrets Manager."
  type        = string
}

variable "associate_public_ip_address"{
  description = "Determines whether to associate a public IP address with an instance in a VPC."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The Availbility Zone to start the instance in."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "The ID of the Availability Zone for the subnet. Argument not supported in all regions or partitions."
  type        = string
  default     = null
}

variable "capacity_reservation_specification" {
  description = "A configuration block for the instance's Capacity Reservation targeting option."
  type = object({
    capacity_reservation_preference = optional(string)
    
    capacity_reservation_target = optional(object({
      capacity_reservation_id = optional(string)
      resource_group_arn      = optional(string)
    }))
  })
  default = null
}

variable "cidr_block" {
  description = "The CIDR block of the desired subnet."
  type        = string
  default     = null
}

variable "cpu_core_count" {
  description = "The number of CPU cores for the instance."
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "The number of threads per CPU core. If set to 1, hyperthreading is disabled on the launch of the instance."
  type        = number
  default     = null
}

variable "credit_specification" {
  description = "A configuration block for customizing the credit specification of the instance."
  type = object({
    cpu_credits = optional(string)
  })
  default = null
}

variable "disable_api_stop" {
  description = "Determines whether EC2 Instance Stop Protection is enabled."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Determines whether EC2 Instance Termination Protection is enabled."
  type        = bool
  default     = false
}

variable "enable_ebs_optimization" {
  description = "Determines whether the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "enable_hibernation_support" {
  description = "Determines whether the launched EC2 instance will support hibernation."
  type        = bool
  default     = false
}

variable "enable_instance_monitoring" {
  description = "Determines whether detailed monitoring of the instance will be enabled."
  type        = bool
  default     = false
}

variable "enable_volume_tags" {
  description = "Determines if tags will be assigned to root and EBS volumes."
  type        = bool
  default     = true
}

variable "enclave_options" {
  description = "A configuration block to enable nitro enclaves on launched instances."
  type = object({
    enabled = optional(bool)
  })
  default = null
}

variable "env_name" {
  type = string
  
  validation {
    condition = length(var.env_name) ==2
    error_message = "environment name should be of two characters"
  }
}

variable "env_type" {
  description = "High-Level environment grouping. Development includes Unit Test, Integration Test, System Test, Regression Test, Dev, Scrum, System Integration Test etc."
  type        = string

  validation {
    condition     = contains(["dev", "pft", "uat", "sbx", "prd"], var.env_type)
    error_message = "Valid values for env_type are ['dev', 'pft', 'uat', 'sbx', 'prd']."
  }
}

variable "ephemeral_block_device" {
  description = "One or more configuration blocks to customize ephemeral (Instance Store) volumes on the instance."
  type = object({
    device_name  = string
    no_device    = optional(bool)
    virtual_name = optional(string)
  })
  default = null
}

variable "filter" {
  description = "A configuration block for filtering subnets by Name and Values."
  type = object({
    name   = string
    values = set(string)
  })
  default = null
}

variable "get_password_data" {
  description = "Determines whether password data will be retrieved once available."
  type        = bool
  default     = false
}

variable "host_id" {
  description = "The ID of a dedicated host to which the instance will be assigned."
  type        = string
  default     = null
}

variable "host_resource_group_arn" {
  description = "The ARN of the host resource group in which to launch the instances. If specified, omit the 'tenancy' parameter or set it to 'host'."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to launch with the instance. Specified as the name of the instance profile."
  type        = string
  default     = null
}

variable "include_deprecated_ami" {
  description = "Determines if all deprecated AMIs are included in the response."
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "The shutdown behavior for the instance."
  type        = string
  default     = "stop"

  validation {
    condition     = contains(["reboot", "stop", "hibernate", "terminate"], var.instance_initiated_shutdown_behavior)
    error_message = "Valid values for instance_initiated_shutdown_behavior are ['reboot', 'stop', 'hibernate', 'terminate']."
  }
}

variable "instance_profile_name" {
  description = "The name of the instance profile."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  type        = string
}

variable "ipv6_address_count" {
  description = "The number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  type        = number
  default     = 0
}

variable "ipv6_addresses" {
  description = "A list of one or more IPv6 addresses from the range of the subnet to associate with the primary network interface."
  type        = list(string)
  default     = null
}

variable "ipv6_cidr_block" {
  description = "The IPv6 CIDR block of the desired subnet."
  type        = string
  default     = null
}

variable "key_name" {
  description = "The key name of the key pair to user for the instance."
  type        = string
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template."
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null
}

variable "maintenance_options" {
  description = "A configuration block to customize the maintenance and recovery options for the instance."
  type = object({
    auto_recovery = optional(string)
  })
  default = null
}

variable "metadata_options" {
  description = "A configuration block to customize the metadata options for the instance."
  type = object({
    enable_http_endpoint        = optional(string)
    enable_metadata_tags        = optional(string)
    http_put_response_hop_limit = optional(number)
    http_tokens                 = optional(string)
  })
  default = null
}

variable "most_recent_ami" {
  description = "Determines whether the most recent AMI is used if more than one result is returned."
  type        = bool
  default     = true
}

variable "network_interface_settings" {
  description = "A configuration block for customizing the network interface settings of the instance."
  type = object({
    device_index         = number
    network_card_index   = optional(number)
    network_interface_id = string
  })
  default = null
}

variable "ordinal" {
  type        = number
  description = "The sequence number for the instance name. The value must be between 00 and 99."
  default     = 00

  validation {
    condition     = var.ordinal >= 00 && var.ordinal <= 99
    error_message = "Value can be no more than two digits."
  }
}

variable "organization" {
  description = "The name of the organization."
  type        = string
  default     = "fepoc"
}

variable "placement_group" {
  description = "The placement group to start the instance in."
  type        = string
  default     = null
}

variable "placement_partition_number" {
  description = "The number of the partition the instance is in. Valid only if the associated placement group's strategy is 'partition'."
  type        = number
  default     = null
}

variable "private_dns_name_options" {
  description = "A configuration block to customize the private DNS name options for the instance."
  type = object({
    enable_resource_name_dns_a_record    = optional(bool)
    enable_resource_name_dns_aaaa_record = optional(bool)
    hostname_type                        = optional(string)
  })
  default = null
}

variable "private_ip" {
  description = "The private IP address to associate with the instance in a VPC."
  type        = string
  default     = null
}

#variable "private_key" {
#  description = "The contenst of the SSH key for the remote-exec on the instance."
#  type        = string
#}

variable "region" {
  description = "The AWS region in which the resource belongs."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-east-2"], var.region)
    error_message = "Valid values for region are ['us-east-1', 'us-east-2']"
  }
}

variable "region_short" {
  type = map(string)
  default = {
    "us-east-1" = "e1"
    "us-east-2" = "e2"
  }
}

variable "root_block_device_settings" {
  description = "A configuration block to customize details about the root block device of the instance."
  type = object({
    volume_type           = optional(string)
    volume_size           = optional(number)
    iops                  = optional(number)
    throughput            = optional(number)
    delete_on_termination = optional(bool)
    enable_encryption     = optional(bool)
    kms_key_id            = optional(string)
  })
  default = null
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e., referenced in a network_interface block."
  type        = list(string)
  default     = null
}

variable "service_name" {
  description = "The name of the service that the instance is running. e.g. 'Apache2.0'"
  type        = string
  default     = "Apache2.0"
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = false
}

variable "state" {
  description = "The state that the desired subnet must have."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC subnet ID to launch in."
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags for the resource."
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of 'dedicated' runs on single-tenant hardware. The 'host' tenancy is not supported for the import-instance command."
  type        = string
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "Valid values for tenancy are ['default', 'dedicated', 'host']."
  }
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead. Updates to this field will trigger a stop/start of the EC2 instance by default."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instaed of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Determines if a destroy and recreate is triggered when used in combination with user_data or user_data_base64."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC to which the desired subnet belongs."
  type        = string
  default     = null
}

variable "vpc_name" {
  description = "The name of the VPC from which to get subnet information."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the instance."
  type        = list(string)
  default     = null
}
