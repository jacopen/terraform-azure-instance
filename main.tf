terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "id" {
  keepers = {
    vm_hostname = var.prefix
  }

  byte_length = 6
}

## NICを作る
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-module-nic-${random_id.id.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}ipconfig-${random_id.id.hex}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

## NICにセキュリティグループを割り当て
resource "azurerm_network_interface_security_group_association" "nic_sg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

## パブリックIPをつける
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-module-ip-${random_id.id.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-module-${random_id.id.hex}"
}

## VMを作る
resource "azurerm_virtual_machine" "vm" {
  name                = "${var.prefix}-module-app-${random_id.id.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.nic.id]
  delete_os_disk_on_termination = "true"

  ## ベースとなるイメージ
  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  ## 起動ディスク
  storage_os_disk {
    name              = "${var.prefix}-module-osdisk-${random_id.id.hex}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  ## パスワードとか
  os_profile {
    computer_name  = var.prefix
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {}

  depends_on = [azurerm_network_interface_security_group_association.nic_sg_assoc]
}


resource "azurerm_network_security_group" "sg" {
  name                = "module-sg-${random_id.id.hex}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}