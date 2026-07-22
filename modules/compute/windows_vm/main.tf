resource "azurerm_network_interface" "vm_nic" {
  name                            = "${var.vm_name}-nic"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  accelerated_networking_enabled  = var.enable_accelerated_networking
  tags                            = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = null
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  secure_boot_enabled   = var.security_type == "TrustedLaunch" ? true : false
  vtpm_enabled          = var.security_type == "TrustedLaunch" ? true : false
  zone                  = var.availability_option == "AvailabilityZone" ? var.availability_zone : null

  # Overlooked cost lever: if these VMs are covered by an on-prem Windows
  # Server + Software Assurance agreement, license_type = "Windows_Server"
  # applies Azure Hybrid Benefit and drops the Windows license cost out of
  # the compute rate entirely.
  license_type = var.license_type

  patch_mode             = var.patch_mode
  patch_assessment_mode  = var.patch_assessment_mode

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = var.os_disk_type
    disk_size_gb          = var.os_disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "ama" {
  count = var.enable_monitoring_agent ? 1 : 0

  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.21"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true

  tags = var.tags
}
