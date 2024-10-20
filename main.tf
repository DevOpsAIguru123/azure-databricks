provider "databricks" {
  host  = "https://<databricks-instance>"
  token = "<databricks-token>"
}

provider "azurerm" {
  features {}
}

# Variable for environment
variable "environment" {
  description = "The environment, e.g., dev, test, prod"
  type        = string
}

# Variable for Snowflake connection details (key-value map)
variable "snowflake_details" {
  type = map(object({
    host          = string
    port          = string
    user          = string
    sfwarehouse   = string
    password_name = string
    databases     = list(string)  # List of database names
  }))
}

# Local variable for Key Vault ID (optional optimization)
locals {
  key_vault_id = azurerm_key_vault.example.id  # Replace with your Key Vault resource ID
}

# Key Vault Secret Data Source
data "azurerm_key_vault_secret" "snowflake_passwords" {
  for_each = var.snowflake_details

  name         = each.value.password_name
  key_vault_id = local.key_vault_id
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

# Granting all privileges on the connections to a specified principal
resource "databricks_grants" "connection_grants" {
  for_each = var.snowflake_details

  object_type = "CONNECTION"
  object_name = databricks_connection.snowflake_connections[each.key].name
  privileges  = ["ALL PRIVILEGES"]

  principal = "your_principal_here"  # Replace with the actual user or group
}

# Generating a map for the catalogs to be created
locals {
  database_catalogs = {
    for dc in flatten([
      for conn_key, conn_value in var.snowflake_details : [
        for db_name in conn_value.databases : {
          conn_key   = conn_key
          conn_value = conn_value
          database   = db_name
          catalog    = "${db_name}-${var.environment}"
        }
      ]
    ]) : "${dc.conn_key}-${dc.database}" => dc
  }
}

# Creating Databricks Catalogs for each database
resource "databricks_catalog" "snowflake_catalogs" {
  for_each = local.database_catalogs

  name            = each.value.catalog
  connection_name = databricks_connection.snowflake_connections[each.value.conn_key].name
  comment         = "Catalog for database ${each.value.database}"

  options = {
    database = each.value.database  # Use the database name
  }
}

# Granting all privileges on the catalogs to a specified principal
resource "databricks_grants" "catalog_grants" {
  for_each = local.database_catalogs

  object_type = "CATALOG"
  object_name = databricks_catalog.snowflake_catalogs[each.key].name
  privileges  = ["ALL PRIVILEGES"]

  principal = "your_principal_here"  # Replace with the actual user or group
}
