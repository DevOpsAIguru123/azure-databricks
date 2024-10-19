%pip install --upgrade --no-deps azure-identity azure-keyvault-secrets

from azure.identity import ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient

# Define your Key Vault URL
key_vault_url = "https://demo-kv-test.vault.azure.net/"

# Create a ManagedIdentityCredential instance
credential = ManagedIdentityCredential()

# Create a SecretClient using the managed identity credential
secret_client = SecretClient(vault_url=key_vault_url, credential=credential)

# Retrieve a secret from Key Vault
secret_name = "fff"
secret = secret_client.get_secret(secret_name)

print(f"Retrieved secret: {secret.value}")