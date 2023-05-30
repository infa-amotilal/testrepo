variable "ssl_certificate" {
  # default = "${base64encode(file("/tmp/consul.pfx"))}"
  default = "/Users/amotilal/Desktop/consul_creation/ct_terraform/azure/ichsnp/mgmtplane/consul/westus2/iics-qa-perf1-ma/server.pfx"
} # export certificate using TF_VAR_ssl_certificate

variable "ssl_certificate_password" {
  # default = "changeit"
  default = "password"
} # export certificate using TF_VAR_ssl_certificate_password

variable "location" {
  default = "West US 2"
}

variable "admin_username" {
  default = "centos"
}

variable "name_prefix" {
  default = "ichsnp-iics-qa-perf1-ma"
}

# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = "true" 
  features {}
  subscription_id = "6596c3ff-1969-4352-97dc-d3cc102c7b8d"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"

    }
  }

  backend "azurerm" {
    resource_group_name  = "IICHS-MANAGEMENTPLANE-USWEST2"
    storage_account_name = "tfstatecloudtrustqa"
    container_name       = "tfstatecloudtrustqa"
    key                  = "azure.ichsnp-iics-qa-perf1-ma.consul.westus2.tfstate"
  }
}

module "consul" {
  source       = "/Users/amotilal/Desktop/consul_creation/ct_tfmodules/modules/azure/consul"
  name_prefix  = "${var.name_prefix}"
  rg_name      = "IICHS-MANAGEMENTPLANE-USWEST2"
  location     = "${var.location}"
  vnet_name    = "IICHS-MANAGEMENTPLANE-USWEST2-NP"
  vnet_rg_name = "INFRASTRUCTURE-DEV-VNET-USWEST2"
  azvault_name = ""

  instance_count    = 0
  instance_sku_name = "Standard_D2s_v3"
  instance_sku_tier = "Standard"

  agw_subnet_name = "application-gateway"
  app_subnet_name = "OPS"

  sshkey_pub = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJOAczv0XGAITRX+NVSXi2IBbFXWik+/mbKrOymFl3HpBAkOOL+k9OA8sG0GBENj4Fs81Krv6HwFojH3PQBfgO0cE/d9+dkZUmC6dYH3Hjc/1M0AxxrSpBUgWaoO0BiS3Mhqg/2guCOVtn4/Vji6hA0tr3k1OLN2i6nnhk7bRfsI/MQLGRXv5EUNyrAlAvDOlaexqWE0GI+u4FbWYXJo6HA/deAtBhjLyKA+H4XVcgqkygjnhwLl8Myf3wBEsZQx+EH8fJ62i9iki1phvZJGXrQLfzDuUl9lx7DK4WVmmkMjryVLYRSh4apSVx34NyUOu604zz7s0ey7jTsB7pixJ5"

  servicename    = "CONSUL"
  businessunit   = "INFRASTRUCTURE"
  alertgroup     = "ops_team"
  env            = "QA"
  image_id       = "/subscriptions/3d1a4cb3-087d-4c0c-90d0-ed3f2951af88/resourceGroups/Infa-Production-Images/providers/Microsoft.Compute/galleries/ubiimagegallery/images/ctcentos7def/versions/2023.04.2"
  admin_username = "${var.admin_username}"

  owneremail               = "DLCLOUDTRUSTOPS@INFORMATICA.COM"
  secret_prefix            = "${var.name_prefix}-consul"
  # azvault_name             = "iichs-mgmtplane-np"
  # datacenter               = "ichsnp-iics-qa-perf1-ma"
  ssl_certificate          = "${var.ssl_certificate}"
  ssl_certificate_password = "${var.ssl_certificate_password}"
}
