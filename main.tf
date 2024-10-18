provider "databricks" {
  host  = "https://<databricks-instance>"
  token = "<databricks-token>"
}

provider "azurerm" {
  features {}
}

# Variable for Snowflake connection details (key-value map)
variable "snowflake_details" {
  type = map(object({
    host          = string
    port          = string
    user          = string
    sfwarehouse   = string
    password_name = string
    catalog       = string
  }))
}

# Key Vault Secret Data Source
data "azurerm_key_vault_secret" "snowflake_passwords" {
  for_each = var.snowflake_details

  name         = each.value.password_name
  key_vault_id = azurerm_key_vault.example.id  # replace with your Key Vault resource ID
}

# Creating Databricks Snowflake Connections
resource "databricks_connection" "snowflake_connections" {
  for_each = var.snowflake_details

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
    purpose = "Snowflake connection ${each.key}"
  }
}

# Creating Databricks Catalogs for each connection
resource "databricks_catalog" "snowflake_catalogs" {
  for_each = var.snowflake_details

  name         = each.value.catalog  # Use the catalog name (e.g., db1)
  comment      = "Catalog for Snowflake connection ${each.key}"
  provider_name = databricks_connection.snowflake_connections[each.key].name  # Reference the connection name
}


