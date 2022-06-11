variable "location" {
  type = string
  default = "japaneast"
}
variable "resource_group_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "prefix" {
  type = string
  default = ""
}
variable "vm_size" {
  type = string
  default = "Standard_B1ls"
}
variable "image_publisher" {
  type = string
  default = "Canonical"
}
variable "image_offer" {
  type = string
  default = "UbuntuServer"
}
variable "image_sku" {
  type = string
  default = "16.04-LTS"
}
variable "image_version" {
  type = string
  default = "latest"
}
variable "admin_username" {
  type = string
  default = "azureuser"
}
variable "admin_password" {
  type = string
  default = "Password123!"
}
variable "managed_disk_type" {
  type = string
  default = "Standard_LRS"
}
variable "additional_disk_name" {
  type = string
  default = ""
}
variable "additional_disk_size" {
  type = number
  default = 20
}
variable "additional_disk_tags" {
  type = map
  default = {}
}
