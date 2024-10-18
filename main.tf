provider "databricks" {
  host  = "https://<databricks-instance>"
  token = "<databricks-token>"
}

provider "azurerm" {
  features {}
}

# Key Vault Secret Data Source
data "azurerm_key_vault_secret" "snowflake_passwords" {
  for_each = var.snowflake_passwords

  name         = each.value
  key_vault_id = azurerm_key_vault.example.id  # replace with your Key Vault resource ID
}

# Variable for Snowflake connections
variable "snowflake_connections" {
  type = map(object({
    host        = string
    port        = string
    user        = string
    sfwarehouse = string
    purpose     = string
  }))
}

# Variable for Key Vault secret names
variable "snowflake_passwords" {
  type = map(string)
}

# Creating Databricks Snowflake Connections
resource "databricks_connection" "snowflake_connections" {
  for_each = var.snowflake_connections

  name            = each.key
  connection_type = "SNOWFLAKE"
  comment         = "Connection to Snowflake Data Warehouse"

  options = {
    host        = each.value.host
    port        = each.value.port
    user        = each.value.user
    sfwarehouse = each.value.sfwarehouse
    password    = data.azurerm_key_vault_secret.snowflake_passwords[each.key].value
  }

  properties = {
    purpose = each.value.purpose
  }
}

# Example Azure Key Vault resource definition (if needed)
resource "azurerm_key_vault" "example" {
  name                = "example-vault"
  location            = "East US"
  resource_group_name = "example-resource-group"
  tenant_id           = "<tenant_id>"
  sku_name            = "standard"
}
