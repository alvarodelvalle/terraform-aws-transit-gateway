variable "tags" {
  description = "A map of tags to add to all resources"
  type        = object({})
  default = {
    CreatedBy           = "MissionCloud"
    Terraform           = true
    "Terraform::Module" = "terraform-aws-transit-gateway"
  }
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "vpcs" {
  description = "VPC's defined as a map"
  type        = any
  default = {
    #    vpc-security-us-east = {
    #      cidr_block                       = "10.201.0.0/16"
    #      instance_tenancy                 = "default"
    #      enable_dns_support               = true
    #      enable_dns_hostnames             = false
    #      enable_classiclink               = null
    #      enable_classiclink_dns_support   = null
    #      assign_generated_ipv6_cidr_block = false
    #      tags = {
    #        Name    = "vpc-security-us-east"
    #        Purpose = "Security VPC for all traffic inspection"
    #      }
    #      igw_tags = {
    #        Name        = "igw-security-us-east"
    #        VPCOwner    = "vpc-security-us-east"
    #        Description = "Internet Gateway for Security VPC"
    #      }
    #    }
  }
}

variable "private_subnets" {
  description = "Private subnets defined as a map.  See default for an example"
  type        = any
  default = {
    #    sn-security-mgmt-us-east-1a = {
    #      vpc_name                = "vpc-security-us-east"
    #      availability_zone       = "us-east-1a"
    #      cidr_block              = "10.201.0.0/24"
    #      map_public_ip_on_launch = false
    #      tags = {
    #        Purpose = "Firewall Management Interface"
    #      }
    #    }
  }
}

variable "public_subnets" {
  description = "Public subnets defined as a map. See default for an example"
  type        = any
  default = {
    #    sn-security-public-us-east-1a = {
    #      vpc_name                = "vpc-security-us-east"
    #      availability_zone       = "us-east-1a"
    #      cidr_block              = "10.201.2.0/24"
    #      map_public_ip_on_launch = true
    #      tags = {
    #        Purpose = "Public Facing Interface"
    #      }
    #    }
  }
}

variable "vpc_route_tables" {
  description = "VPC Route Tables"
  type        = any
  default = {
    #    rt-security-mgmt-us-east = {
    #      vpc_name = "vpc-security-us-east"
    #      routes = [
    #        {
    #          route_cidr_destination = "0.0.0.0/0"
    #          transit_gateway_name   = "tgw-security-us-east"
    #        }
    #      ]
    #    }
  }
}

variable "rt_subnet_associations_list" {
  description = "Route table to subnet association"
  type        = list(string)
  default = [
    #    "rt-security-mgmt-us-east:sn-security-mgmt-us-east-1a",
  ]
}

variable "rt_gateway_associations_list" {
  description = "Route table to subnet association"
  type        = list(string)
  default = [
    #    "rt-inbound-public-us-east:vpc-inbound-us-east",
  ]
}

variable "vpc_endpoints" {
  description = "VPC endpoints mapping"
  type        = any
  default = {
    #    gwlbe-security-us-east-1a = {
    #      vpc_name              = "vpc-security-us-east"
    #      endpoint_service_name = "gwlbe-security-us-east"
    #      endpoint_subnets      = ["sn-security-gwlbe-us-east-1a"]
    #      tags = {
    #        Name = "gwlbe-security-us-east-1a"
    #      }
    #    }
  }
}

variable "tgws" {
  description = "Transit Gateways"
  type        = any
  default = {
    #    tgw-security-us-east = {
    #      description                     = "Willdan Group East TGW"
    #      amazon_side_asn                 = 64513
    #      default_route_table_association = "disable"
    #      default_route_table_propagation = "disable"
    #      auto_accept_shared_attachments  = "disable"
    #      dns_support                     = "enable"
    #      vpn_ecmp_support                = "enable"
    #      tags = {
    #        Purpose = "tgw-complete-example"
    #      }
    #    }
  }
}

variable "tgw_vpc_attachments" {
  description = "Transit Gateways VPC attachments"
  type        = any
  default = {
    #    tgw-attach-security-us-east = {
    #      vpc_name                                        = "vpc-security-us-east"
    #      tgw_name                                        = "tgw-security-us-east"
    #      subnets                                         = ["sn-security-tgw-us-east-1a", "sn-security-tgw-us-east-1b"]
    #      description                                     = "VPC attachment to Security VPC"
    #      dns_support                                     = true
    #      ipv6_support                                    = false
    #      appliance_mode_support                          = true
    #      transit_gateway_default_route_table_association = false
    #      transit_gateway_default_route_table_propagation = false
    #      tags                                            = {}
    #    }
  }
}


variable "tgw_route_tables" {
  description = "Transit gateway route tables"
  default = {
    #    tgw-rt-spoke-us-east = {
    #      transit_gateway_name = "tgw-security-us-east"
    #      associations = []
    #      route_propagations = ["tgw-attach-security-us-east", "tgw-attach-inbound-us-east"]
    #      routes = {
    #        "10.201.3.0/24" = {
    #          type       = "Active"
    #          attachment = "tgw-attach-security-us-east"
    #        }
    #        "10.201.67.0/24" = {
    #          type       = "Active"
    #          attachment = "tgw-attach-security-us-east"
    #        }
    #      }
    #      tgw_route_table_tags = {
    #        Purpose = "TGW Route Table for Spoke VPC"
    #      }
    #    }
  }
}

variable "elbs" {
  description = "Elastic load balancers."
  type        = any
  default = {
    #    gwlb-security-us-east = {
    #      type       = "gateway"
    #      cross-zone = true
    #      azs        = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
    #      vpc_name   = "vpc-security-us-east"
    #      subnets = [
    #        "sn-security-gwlb-us-east-1a",
    #        "sn-security-gwlb-us-east-1b",
    #        "sn-security-gwlb-us-east-1c",
    #        "sn-security-gwlb-us-east-1d"
    #      ]
    #      targets = {
    #        gwlb-target-security-us-east = {
    #          type = "ip"
    #          targets = [
    #            "10.201.1.10",
    #            "10.201.64.10"
    #          ]
    #          health_check_path     = "/php/login.php"
    #          health_check_port     = 443
    #          health_check_protocol = "HTTPS"
    #        }
    #      }
    #      listeners = {} #need this ATM because of local.lb_listeners
    #      tags = {
    #        Purpose = "Gateway Load Balancer for Security"
    #      }
    #    }
  }
}

variable "vpc_endpoint_service" {
  description = "VPC endpoint services; include type and target."
  default = {
    #    gwlbe-security-us-east = {
    #      type   = "gateway"
    #      target = "gwlb-security-us-east"
    #      tags = {
    #        Purpose = "gwlbe-security-us-east"
    #      }
    #    }
  }
}

variable "security_groups" {
  description = "Security Groups and in/e/gress rules. Do not use 'sg' in the name."
  default = {
    #    security-mgmt-us-east = {
    #      vpc_name = "vpc-security-us-east"
    #      rules = [
    #        {
    #          description     = "ICMP - Firewall Management"
    #          type            = "ingress"
    #          protocol        = "ICMP"
    #          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
    #          security_groups = null
    #          prefix_list_ids = null
    #          self            = false
    #          from_port       = 8
    #          to_port         = 8
    #        },
    #        {
    #          description     = "SSH - Firewall Management"
    #          type            = "ingress"
    #          protocol        = "TCP"
    #          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
    #          security_groups = null
    #          prefix_list_ids = null
    #          self            = false
    #          from_port       = 22
    #          to_port         = 22
    #        },
    #        {
    #          description     = "HTTPS - Firewall Management"
    #          type            = "ingress"
    #          protocol        = "TCP"
    #          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
    #          security_groups = null
    #          prefix_list_ids = null
    #          self            = false
    #          from_port       = 443
    #          to_port         = 443
    #        },
    #        {
    #          description     = "All - Firewall Management"
    #          type            = "egress"
    #          protocol        = "-1"
    #          cidrs           = ["0.0.0.0/0"]
    #          security_groups = null
    #          prefix_list_ids = null
    #          self            = false
    #          from_port       = 0
    #          to_port         = 0
    #        },
    #      ]
    #      tags = {
    #        Purpose = "Firewall Management"
    #      }
    #    }
  }
}

variable "instances" {
  description = "EC2 instances with their network interfaces"
  type        = any
  default = {
    #    panfw-security-us-east-1a = {
    #      instance_type   = "m5.xlarge"
    #      subnet          = "sn-security-mgmt-us-east-1a"
    #      security_groups = ["security-mgmt-us-east"]
    #      az              = "us-east-1a"
    #      network_interfaces = {
    #        eni-panfw-us-east-1a-mgmt = {
    #          index           = 0
    #          subnet          = "sn-security-mgmt-us-east-1a"
    #          ips             = ["10.201.0.10"]
    #          security_groups = ["security-mgmt-us-east"]
    #          src_dst_check   = false
    #          tags = {
    #            Purpose = "Firewall Management"
    #          }
    #        }
    #        eni-panfw-us-east-1a-private = {
    #          index           = 1
    #          subnet          = "sn-security-private-us-east-1a"
    #          ips             = ["10.201.1.10"]
    #          security_groups = ["security-mgmt-us-east"]
    #          src_dst_check   = false
    #          tags = {
    #            Purpose = "Firewall Private Interface"
    #          }
    #        }
    #        eni-panfw-us-east-1a-public = {
    #          index           = 2
    #          subnet          = "sn-security-public-us-east-1a"
    #          ips             = ["10.201.2.10"]
    #          security_groups = ["security-mgmt-us-east"]
    #          src_dst_check   = false
    #          tags = {
    #            Purpose = "Firewall Public Interface"
    #          }
    #        }
    #      }
    #    }
  }
}

variable "eips" {
  description = "Elastic IP's and allocation"
  type        = any
  default = {
    #    eip-security-panfw-us-east-1a = {
    #      allocation = "eni-panfw-us-east-1a-public"
    #      tags = {
    #        Purpose = "Public Address for Outbound traffic to IGW"
    #      }
    #    }
  }
}
