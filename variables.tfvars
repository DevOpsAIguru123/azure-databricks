# Map of connection details with key-value pairs for each Snowflake connection
snowflake_details = {
  snow_conn_1 = {
    host          = "xyz1.azure.snowflakecomputing.com"
    port          = "443"
    user          = "user1"
    sfwarehouse   = "warehouse1"
    password_name = "snowflake_password_1"  # Key Vault secret name
    catalog       = "db1"  # Database name
  }
  snow_conn_2 = {
    host          = "xyz2.azure.snowflakecomputing.com"
    port          = "443"
    user          = "user2"
    sfwarehouse   = "warehouse2"
    password_name = "snowflake_password_2"
    catalog       = "db2"
  }
  snow_conn_3 = {
    host          = "xyz3.azure.snowflakecomputing.com"
    port          = "443"
    user          = "user3"
    sfwarehouse   = "warehouse3"
    password_name = "snowflake_password_3"
    catalog       = "db3"
  }
  snow_conn_4 = {
    host          = "xyz4.azure.snowflakecomputing.com"
    port          = "443"
    user          = "user4"
    sfwarehouse   = "warehouse4"
    password_name = "snowflake_password_4"
    catalog       = "db4"
  }
  snow_conn_5 = {
    host          = "xyz5.azure.snowflakecomputing.com"
    port          = "443"
    user          = "user5"
    sfwarehouse   = "warehouse5"
    password_name = "snowflake_password_5"
    catalog       = "db5"
  }
}
