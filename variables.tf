variable "tags" {
  description = "A map of tags to add to all resources"
  type        = object({})
  default = {
    CreatedBy           = "MissionCloud"
    Terraform           = true
    "Terraform::Module" = "terraform-aws-transit-gateway"
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
      tags = {
        Name    = "vpc-security-us-east"
        Purpose = "Security VPC for all traffic inspection"
      }
      igw_tags = {
        Name        = "igw-security-us-east"
        VPCOwner    = "vpc-security-us-east"
        Description = "Internet Gateway for Security VPC"
      }
    }
    vpc-inbound-us-east = {
      cidr_block                       = "10.200.0.0/16"
      instance_tenancy                 = "default"
      enable_dns_support               = true
      enable_dns_hostnames             = false
      enable_classiclink               = null
      enable_classiclink_dns_support   = null
      assign_generated_ipv6_cidr_block = false
      tags = {
        Name    = "vpc-inbound-us-east"
        Purpose = "Inbound VPC for all traffic inspection"
      }
      igw_tags = {
        Name        = "igw-inbound-us-east"
        VPCOwner    = "vpc-inbound-us-east"
        Description = "Internet Gateway for Inbound VPC"
      }
    }
  }
}

variable "private_subnets" {
  description = "Private subnets defined as a map.  See default for an example"
  type        = any
  default = {
    sn-security-mgmt-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.0.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Firewall Management Interface"
      }
    },
    sn-security-private-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.1.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Internal Interface"
      }
    },
    sn-security-tgw-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.3.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Transit Gateway Attachment Interface"
      }
    },
    sn-security-gwlbe-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.4.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
    sn-security-gwlb-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.5.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer"
      }
    },
    sn-security-mgmt-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.201.64.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Firewall Management Interface"
      }
    },
    sn-security-private-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.65.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Internal Interface"
      }
    },
    sn-security-tgw-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.201.67.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Transit Gateway Attachment Interface"
      }
    },
    sn-security-gwlbe-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.201.68.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
    sn-security-gwlb-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.201.69.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer"
      }
    },
    sn-security-gwlb-us-east-1c = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1c"
      cidr_block              = "10.201.133.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer"
      }
    },
    sn-security-gwlb-us-east-1d = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1d"
      cidr_block              = "10.201.197.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer"
      }
    },
    sn-inbound-tgw-us-east-1a = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.200.0.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Transit Gateway Attachment Interface"
      }
    },
    sn-inbound-gwlbe-app1-us-east-1a = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.200.2.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
    sn-inbound-gwlbe-app2-us-east-1a = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.200.4.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
    sn-inbound-tgw-us-east-1b = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.200.64.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Transit Gateway Attachment Interface"
      }
    },
    sn-inbound-gwlbe-app1-us-east-1b = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.200.66.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
    sn-inbound-gwlbe-app2-us-east-1b = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.200.68.0/24"
      map_public_ip_on_launch = false
      tags = {
        Purpose = "Gateway Load Balancer Endpoint"
      }
    },
  }
}

variable "public_subnets" {
  description = "Public subnets defined as a map. See default for an example"
  type        = any
  default = {
    sn-security-public-us-east-1a = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.201.2.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Public Facing Interface"
      }
    },
    sn-security-public-us-east-1b = {
      vpc_name                = "vpc-security-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.201.66.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Public Facing Interface"
      }
    }
    sn-inbound-alb-app1-us-east-1a = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.200.1.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Application Load Balancer"
      }
    },
    sn-inbound-alb-app2-us-east-1a = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1a"
      cidr_block              = "10.200.3.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Application Load Balancer"
      }
    },
    sn-inbound-alb-app1-us-east-1b = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.200.65.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Application Load Balancer"
      }
    },
    sn-inbound-alb-app2-us-east-1b = {
      vpc_name                = "vpc-inbound-us-east"
      availability_zone       = "us-east-1b"
      cidr_block              = "10.200.67.0/24"
      map_public_ip_on_launch = true
      tags = {
        Purpose = "Application Load Balancer"
      }
    },
  }
}

variable "vpc_route_tables" {
  description = "VPC Route Tables"
  default = {
    rt-security-mgmt-us-east = {
      vpc_name = "vpc-security-us-east"
      routes = [
        {
          route_cidr_destination    = "0.0.0.0/0"
          transit_gateway_name      = "tgw-security-us-east"
          route_subnets_association = ["sn-security-mgmt-us-east-1a", "sn-security-mgmt-us-east-1b"]
        }
      ]
    },
    rt-security-public-us-east = {
      vpc_name = "vpc-security-us-east"
      routes = [
        {
          route_cidr_destination    = "0.0.0.0/0"
          gateway_name              = "igw-security-us-east"
          route_subnets_association = ["sn-security-public-us-east-1a", "sn-security-public-us-east-1b"]
        }
      ]
    },
    rt-security-private-us-east = {
      vpc_name = "vpc-security-us-east"
      routes   = []
    },
    rt-security-tgw-us-east-1a = {
      vpc_name = "vpc-security-us-east"
      routes = [
        {
          route_cidr_destination    = "0.0.0.0/0"
          vpc_endpoint_name         = "gwlbe-security-us-east-1a"
          route_subnets_association = ["sn-security-tgw-us-east-1a"]
        }
      ]
    },
    rt-security-tgw-us-east-1b = {
      vpc_name = "vpc-security-us-east"
      routes = [
        {
          route_cidr_destination    = "0.0.0.0/0"
          vpc_endpoint_name         = "gwlbe-security-us-east-1b"
          route_subnets_association = ["sn-security-tgw-us-east-1b"]
        }
      ]
    },
    rt-security-gwlbe-us-east = {
      vpc_name = "vpc-security-us-east"
      routes = [
        {
          route_cidr_destination    = "0.0.0.0/0"
          transit_gateway_name      = "tgw-security-us-east"
          route_subnets_association = ["sn-security-gwlbe-us-east-1a", "sn-security-gwlbe-us-east-1b"]
        }
      ]
    },

  }
}

variable "route_table_subnet_associations" {
  description = ""
  default = {
    rt-security-mgmt-us-east = {
      route_subnet_association = "sn-security-mgmt-us-east-1a"
    },
    rt-security-mgmt-us-east = {
      route_subnet_association = "sn-security-mgmt-us-east-1b"
    },
    rt-security-public-us-east = {
      route_subnet_association = "sn-security-public-us-east-1a"
    },
    rt-security-public-us-east = {
      route_subnet_association = "sn-security-public-us-east-1b"
    },
    rt-security-private-us-east = {
      route_subnet_association = "sn-security-private-us-east-1a"
    },
    rt-security-private-us-east = {
      route_subnet_association = "sn-security-private-us-east-1b"
    },
    rt-security-tgw-us-east-1a = {
      route_subnet_association = "sn-security-tgw-us-east-1a"
    },
    rt-security-tgw-us-east-1b = {
      route_subnet_association = "sn-security-tgw-us-east-1b"
    },
    rt-security-gwlbe-us-east = {
      route_subnet_association = "sn-security-gwlbe-us-east-1a"
    },
    rt-security-gwlbe-us-east = {
      route_subnet_association = "sn-security-gwlbe-us-east-1b"
    }
  }
}

variable "vpc_endpoints" {
  description = ""
  type        = map(any)
  default = {
    gwlbe-security-us-east-1a = {
      vpc_name              = "vpc-security-us-east"
      endpoint_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-03c15019b985b9d19"
      endpoint_subnet       = "sn-security-gwlbe-us-east-1a"
    },
    gwlbe-security-us-east-1b = {
      vpc_name              = "vpc-security-us-east"
      endpoint_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-03c15019b985b9d19"
      endpoint_subnet       = "sn-security-gwlbe-us-east-1b"
    }
  }
}

variable "tgws" {
  description = ""
  type        = map(any)
  default = {
    tgw-security-us-east = {
      description                     = "Willdan Group East TGW"
      amazon_side_asn                 = 64513
      default_route_table_association = "disable"
      default_route_table_propagation = "disable"
      auto_accept_shared_attachments  = "disable"
      dns_support                     = "enable"
      vpn_ecmp_support                = "enable"
      tags = {
        Purpose = "tgw-complete-example"
      }
    }
  }
}

variable "tgw_vpc_attachments" {
  description = ""
  type        = any
  default = {
    tgw-attach-security-us-east = {
      vpc_name                                        = "vpc-security-us-east"
      tgw_name                                        = "tgw-security-us-east"
      subnets                                         = ["sn-security-tgw-us-east-1a", "sn-security-tgw-us-east-1b"]
      description                                     = "VPC attachment to Security VPC"
      dns_support                                     = true
      ipv6_support                                    = false
      appliance_mode_support                          = true
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
    }
    tgw-attach-inbound-us-east = {
      vpc_name                                        = "vpc-inbound-us-east"
      tgw_name                                        = "tgw-security-us-east"
      subnets                                         = ["sn-inbound-tgw-us-east-1a", "sn-inbound-tgw-us-east-1b"]
      description                                     = "VPC attachment to Inbound VPC"
      dns_support                                     = true
      ipv6_support                                    = false
      appliance_mode_support                          = true
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
    }
  }
}

variable "tgw_route_tables" {
  description = ""
  default = {
    #TODO - add more context and tf resources in main.tf once vpc's are defined
    tgw-rt-spoke-us-east = {
      transit_gateway_name = "tgw-security-us-east"
      # vpc_associations     = ["vpc-security-us-east", "vpc-inbound-us-east"]
      vpc_associations   = []
      route_propagations = ["tgw-attach-security-us-east"]
      routes             = ["10.201.3.0/24", "10.201.67.0/24"]
      tgw_route_table_tags = {
        Purpose = "TGW Route Table for Spoke VPC"
      }
    }
    tgw-rt-security-us-east = {
      transit_gateway_name = "tgw-security-us-east"
      vpc_associations     = ["tgw-attach-security-us-east"]
      route_propagations   = ["vpc-security-us-east", "vpc-inbound-us-east", "tgw-attach-security-us-east"]
      # routes               = ["10.201.3.0/24", "10.201.67.0/24"]
      routes = ["10.201.3.0/24"]
      tgw_route_table_tags = {
        Purpose = "TGW Route Table for Security VPC"
      }
    }
    tgw-rt-inbound-us-east = {
      transit_gateway_name = "tgw-security-us-east"
      vpc_associations     = ["tgw-attach-inbound-us-east"]
      route_propagations   = ["tgw-attach-inbound-us-east"]
      routes               = []
      tgw_route_table_tags = {
        Purpose = "TGW Route Table for Inbound VPC"
      }
    }
  }
}

variable "elbs" {
  description = ""
  type        = any
  default = {
    gwlb-security-us-east = {
      type       = "gateway"
      cross-zone = true
      azs        = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
      vpc_name   = "vpc-security-us-east"
      subnets = [
        "sn-security-gwlb-us-east-1a",
        "sn-security-gwlb-us-east-1b",
        "sn-security-gwlb-us-east-1c",
        "sn-security-gwlb-us-east-1d"
      ]
      targets = {
        gwlb-target-security-us-east = {
          type = "ip"
          targets = [
            "10.201.1.10",
            "10.201.64.10"
          ]
        }
      }
      listeners = {} #need this ATM because of local.lb_listeners
      tags = {
        Purpose = "Gateway Load Balancer for Security"
      }
    }
    alb-inbound-app1-us-east = {
      type       = "application"
      cross-zone = true
      azs        = ["us-east-1a", "us-east-1b"]
      vpc_name   = "vpc-inbound-us-east"
      subnets = [
        "sn-inbound-alb-app1-us-east-1a",
        "sn-inbound-alb-app1-us-east-1b"
      ]
      security_groups = ["inbound-public-us-east"]
      targets = {
        alb-target-inbound-app1-us-east = {
          type = "ip"
          targets = [
            #TODO - IP Addresses of application servers and ports
          ]
        }
      }
      listeners = {
        http = {
          protocol     = "HTTP"
          port         = "80"
          target_group = "alb-target-inbound-app1-us-east"
        }
      }
      tags = {
        Purpose = "Load Balancer for apps"
      }
    }
    alb-inbound-app2-us-east = {
      type            = "application"
      cross-zone      = true
      azs             = ["us-east-1a", "us-east-1b"]
      vpc_name        = "vpc-inbound-us-east"
      security_groups = ["inbound-public-us-east"]
      subnets = [
        "sn-inbound-alb-app2-us-east-1a",
        "sn-inbound-alb-app2-us-east-1b"
      ]
      targets = {
        alb-target-inbound-app2-us-east = {
          type = "ip"
          targets = [
            #TODO - IP Addresses of application servers and ports
          ]
        }
      }
      listeners = {
        http = {
          protocol     = "HTTP"
          port         = "80"
          target_group = "alb-target-inbound-app2-us-east"
        }
      }
      tags = {
        Purpose = "Load Balancer for apps"
      }
    }
  }
}

variable "vpc_endpoint_service" {
  description = ""
  default = {
    gwlbe-security-us-east = {
      type   = "gateway"
      target = "gwlb-security-us-east"
    }
  }
}

variable "security_groups" {
  description = ""
  default = {
    security-mgmt-us-east = {
      vpc_name = "vpc-security-us-east"
      rules = [
        {
          description     = "ICMP - Firewall Management"
          type            = "ingress"
          protocol        = "ICMP"
          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 8
          to_port         = 8
        },
        {
          description     = "SSH - Firewall Management"
          type            = "ingress"
          protocol        = "TCP"
          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 22
          to_port         = 22
        },
        {
          description     = "HTTPS - Firewall Management"
          type            = "ingress"
          protocol        = "TCP"
          cidrs           = ["10.201.0.0/24", "10.201.64.0/24"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 443
          to_port         = 443
        },
        {
          description     = "All - Firewall Management"
          type            = "egress"
          protocol        = "-1"
          cidrs           = ["0.0.0.0/0"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 0
          to_port         = 0
        },
      ]
      tags = {
        Purpose = "Firewall Management"
      }
    }
    security-private-us-east = {
      vpc_name = "vpc-security-us-east"
      rules = [
        {
          description     = "All - Firewall Private Interface"
          type            = "ingress"
          protocol        = "-1"
          cidrs           = ["10.201.1.0/24", "10.201.65.0/24"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 0
          to_port         = 0
        },
        {
          description     = "All - Firewall Private Interface"
          type            = "egress"
          protocol        = "-1"
          cidrs           = ["0.0.0.0/0"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 0
          to_port         = 0
        },
      ]
      tags = {
        Purpose = "Firewall Private Interface"
      }
    }
    security-public-us-east = {
      vpc_name = "vpc-security-us-east"
      rules = [
        {
          description     = "All - Firewall Private Interface"
          type            = "egress"
          protocol        = "-1"
          cidrs           = ["0.0.0.0/0"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 0
          to_port         = 0
        },
      ]
      tags = {
        Purpose = "Firewall Public Interface"
      }
    }
    inbound-public-us-east = {
      vpc_name = "vpc-inbound-us-east"
      rules = [
        {
          description     = "All - Load Balancer Public"
          type            = "ingress"
          protocol        = "TCP"
          cidrs           = ["0.0.0.0/0"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 80
          to_port         = 80
        },
        {
          description     = "All - Load Balancer Public"
          type            = "egress"
          protocol        = "-1"
          cidrs           = ["0.0.0.0/0"]
          security_groups = null
          prefix_list_ids = null
          self            = false
          from_port       = 0
          to_port         = 0
        },
      ]
      tags = {
        Purpose = "Load Balancer Public"
      }
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

variable "tgw_vpc_attachment_tags" {
  description = "Additional tags for VPC attachments"
  type        = map(string)
  default     = null
}
