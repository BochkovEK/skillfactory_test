# Declaring variables for user-defined parameters

variable "zone" {
  type = string
}

variable "zone_2" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "vm_user" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}


# Adding other variables

locals {
  network_name       = "web-network"
  subnet_name        = "subnet1"
  subnet_name_2      = "subnet2"
  sg_vm_name         = "sg-web"
#  vm_name            = "lemp-vm"
#  vm_name_2          = "lamp-vm"
#  dns_zone_name      = "example-zone"
}


# Setting up the provider

terraform {
  required_providers {
    yandex = {
      version = "0.103.0"
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

    backend "s3" {
      endpoints = {
        s3 = "https://storage.yandexcloud.net"
      }

      bucket = "buckettt"
      region = "ru-central1"
      key    = "test_folder/terraform.tfstate"

      skip_region_validation      = true
      skip_credentials_validation = true
      skip_requesting_account_id  = true # необходимая опция Terraform для версии 1.6.1 и старше.
      skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
    }
}

provider "yandex" {
  folder_id                 = var.folder_id
  token                     = var.token
  cloud_id                  = var.cloud_id
  zone                      = var.zone
}

# Creating a cloud network

resource "yandex_vpc_network" "network-1" {
  name = local.network_name
}

# Creating a subnet

resource "yandex_vpc_subnet" "subnet-1" {
  name           = local.subnet_name
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.network-1.id
}

resource "yandex_vpc_subnet" "subnet-2" {
  name           = local.subnet_name_2
  v4_cidr_blocks = ["192.168.2.0/24"]
  zone           = var.zone_2
  network_id     = yandex_vpc_network.network-1.id
}

# Creating a security group

resource "yandex_vpc_security_group" "sg-1" {
  name        = local.sg_vm_name
  network_id  = yandex_vpc_network.network-1.id
  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  # from myself
  ingress {
    protocol       = "ICMP"
    description    = "ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "ANY"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

module "ya_instance_1" {
  source                = "./modules"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet-1.id
  security_group_ids    = [yandex_vpc_security_group.sg-1.id]
  vm_user               = var.vm_user
  ssh_key_path          = var.ssh_key_path
  zone                  = var.zone
}

module "ya_instance_2" {
  source                = "./modules"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet-2.id
  security_group_ids    = [yandex_vpc_security_group.sg-1.id]
  vm_user               = var.vm_user
  ssh_key_path          = var.ssh_key_path
  zone                  = var.zone_2
}

# Add target group
resource "yandex_lb_target_group" "target-group" {
  # forbidden: "_"
  name           = "target-group"

  target {
    subnet_id   = module.ya_instance_1.subnet_id
    address     = module.ya_instance_1.ip_address
    #ip_address   = module.ya_instance_1.ip_address #"<внутренний_IP-адрес_ВМ_1>"
  }

  target {
    subnet_id   = module.ya_instance_2.subnet_id #"<идентификатор_подсети>"
    address     = module.ya_instance_2.ip_address
    #ip_address   = module.ya_instance_2.ip_address #"<внутренний_IP-адрес_ВМ_2>"
  }
}

#/*
# Add lbn
resource "yandex_lb_network_load_balancer" "network_load_balancer" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
        #path = "/ping"
      }
    }
  }
}
#*/