variable "location" {
  default = "japaneast"
}
variable "resource_group_name" {
}
variable "subnet_id" {
}
variable "prefix" {
  default = ""
}
variable "vm_size" {
  default = "Standard_B1ls"
}
variable "image_publisher" {
  default = "Canonical"
}
variable "image_offer" {
  default = "UbuntuServer"
}
variable "image_sku" {
  default = "16.04-LTS"
}
variable "image_version" {
  default = "latest"
}
variable "admin_username" {
  default = "azureuser"
}
variable "admin_password" {
  default = "Password123!"
}
variable "managed_disk_type" {
  default = "Standard_LRS"
}
