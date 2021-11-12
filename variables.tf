variable "tags" {
  description = "A map of tags to add to all resources"
  type        = object({})
  default = {
    CreatedBy           = "MissionCloud"
    Terraform           = true
    "Terraform::Module" = "terraform-aws-transit-gateway"
  }
}

variable "private_subnets" {
  description = "Private subnets defined as a map.  See default for an example"
  type        = any
  default = {
    sn-security-mgmt-us-east-1a = {
      vpc_name = "vpc-security-us-east"
      availability_zone = "us-east-1a"
      cidr_block = "10.201.0.0/24"
      tags = {
        Purpose = "Firewall Management Interface"
      }
    },
    sn-security-mgmt-us-east-1b = {
      vpc_name = "vpc-security-us-east"
      availability_zone = "us-east-1b"
      cidr_block = "10.201.64.0/24"
      tags = {
        Purpose = "Firewall Management Interface"
      }
    }
  }
}

variable "public_subnets" {
  description = "Public subnets defined as a map. See default for an example"
  type        = any
  default = {
    sn-security-public-us-east-1a = {
      vpc_name = "vpc-security-us-east"
      availability_zone = "us-east-1a"
      cidr_block = "10.201.2.0/24"
      tags = {
        Purpose = "Public Facing Interface"
      }
    }
  }
}

variable "vpcs" {
  description = "VPC's defined as a map"
  type        = any
  default = {
    vpc-security-us-east = {
      cidr_block                       = "10.201.0.0/16"
      instance_tenancy                 = "default"
      enable_dns_support               = true
      enable_dns_hostnames             = false
      enable_classiclink               = null
      enable_classiclink_dns_support   = null
      assign_generated_ipv6_cidr_block = false
      route_tables = {
        rt-security-mgmt-us-east = {
          name = "rt-security-mgmt-us-east"
          routes = [
            {
              route_destination = "0.0.0.0/0"
              route_target = "tgw-security-us-east"
              route_target_type = "TGW"
              route_subnet_association = ["sn-security-mgmt-us-east-1a", "sn-security-mgmt-us-east-1b"]
            }
          ]
        }
      }
      tags = {
        Name = "vpc-security-us-east"
        Purpose = "Security VPC for all traffic inspection"
      }
      igw_tags = {
        Name        = "igw-security-us-east"
        VPCOwner = "vpc-security-us-east"
        Description = "Internet Gateway for Security VPC"
      }
    }
  }
}

variable "tgw_and_attachments" {
  default = {
    name                           = "tgw-security"
    description                    = "Willdan Group East TGW"
    amazon_side_asn                = 64512
    auto_accept_shared_attachments = "disabled"
    dns_support                    = "enabled"
    vpn_ecmp_support               = "enabled"
    ram_allow_external_principals  = true
    ram_principals                 = [123456789098]
    vpc_attachments = {
      vpc-security = {
        cidr_block                                      = "172.31.0.0/16"
        instance_tenancy                                = "default"
        enable_dns_support                              = true
        enable_dns_hostnames                            = false
        enable_classiclink                              = null
        enable_classiclink_dns_support                  = null
        assign_generated_ipv6_cidr_block                = false
        transit_gateway_default_route_table_association = false
        transit_gateway_default_route_table_propagation = false
        tgw_routes = [
          {
            destination_cidr_block = "50.0.0.0/16"
          },
          {
            blackhole              = true
            destination_cidr_block = "10.10.10.10/32"
          }
        ]
        public_subnets = {
          sn-security-public-1a = {
            vpc_id            = ""
            availability_zone = "us-east-1a"
            cidr_block        = "172.31.2.0/24"
            tags = {
              Purpose = "Public Facing Interface"
            }
          },
          sn-security-public-1b = {
            vpc_id            = ""
            availability_zone = "us-east-1b"
            cidr_block        = "172.31.66.0/24"
            tags = {
              Purpose = "Public Facing Interface"
            }
          }
        }

        private_subnets = {
          sn-security-mgmt-1a = {
            vpc_id            = ""
            availability_zone = "us-east-1a"
            cidr_block        = "172.31.0.0/24"
            tags = {
              Purpose = "Firewall Management Interface"
            }
          }
        }

        tags = {
          Name = "vpc-security"
        }

        igw_tags = {
          Name        = "igw-security"
          Description = "Internet Gateway for Security VPC"
        }
      }
    }

    tags = {
      Purpose = "tgw-complete-example"
    }
  }
}

variable "create_tgw" {
  description = "Controls if TGW should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN."
  type        = string
  default     = "64512"
}

variable "enable_auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = bool
  default     = false
}

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = true
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the EC2 Transit Gateway"
  type        = string
  default     = null
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the TGW"
  type        = bool
  default     = true
}

variable "enable_vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = bool
  default     = true
}

# VPC attachments
variable "vpc_attachments" {
  description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
  type        = any
  default     = {}
}

# TGW Route Table association and propagation
variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table to use with the Target Gateway when reusing it between multiple TGWs"
  type        = string
  default     = null
}

variable "tgw_tags" {
  description = "Additional tags for the TGW"
  type        = map(string)
  default     = {}
}

variable "tgw_route_table_tags" {
  description = "Additional tags for the TGW route table"
  type        = map(string)
  default     = {}
}

variable "tgw_default_route_table_tags" {
  description = "Additional tags for the Default TGW route table"
  type        = map(string)
  default     = {}
}

variable "tgw_vpc_attachment_tags" {
  description = "Additional tags for VPC attachments"
  type        = map(string)
  default     = {}
}

# TGW resource sharing
variable "share_tgw" {
  description = "Whether to share your transit gateway with other accounts"
  type        = bool
  default     = true
}

variable "ram_name" {
  description = "The name of the resource share of TGW"
  type        = string
  default     = ""
}

variable "ram_allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = false
}

variable "ram_tags" {
  description = "Additional tags for the RAM"
  type        = map(any)
  default     = null
}

variable "ram_principals" {
  description = "A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
  default     = []
}

variable "ram_resource_share_arn" {
  description = "ARN of RAM resource share"
  type        = string
  default     = ""
}
