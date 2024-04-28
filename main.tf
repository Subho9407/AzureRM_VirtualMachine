resource "azurerm_resource_group" "testvmrg" {
  name     = "todoappvmrg"
  location = "Central India"
}

resource "azurerm_virtual_network" "testvmvnet" {
  name                = "todoappvmvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.testvmrg.location
  resource_group_name = azurerm_resource_group.testvmrg.name
}

resource "azurerm_subnet" "testvmsubnet" {
  name                 = "todoappvmsubnet"
  resource_group_name  = azurerm_resource_group.testvmrg.name
  virtual_network_name = azurerm_virtual_network.testvmvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "testvmpip" {
  name                = "todoappvmpip"
  resource_group_name = azurerm_resource_group.testvmrg.name
  location            = azurerm_resource_group.testvmrg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "testvmnic" {
  name                = "todoappvmnic"
  location            = azurerm_resource_group.testvmrg.location
  resource_group_name = azurerm_resource_group.testvmrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.testvmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.testvmpip.id
  }
}

resource "azurerm_linux_virtual_machine" "todoappvm" {
  name                = "todoappvm"
  resource_group_name = azurerm_resource_group.testvmrg.name
  location            = azurerm_resource_group.testvmrg.location
  size                = "Standard_F2"
  admin_username      = "DevOpsAdmin"
  admin_password      = "DevOpsUser@987"
  network_interface_ids = [
    azurerm_network_interface.testvmnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  disable_password_authentication = false

}

