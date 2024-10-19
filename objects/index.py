from azure.identity import DefaultAzureCredential
from azure.search.documents.indexes import SearchIndexClient

# Set up your Azure Search service details
search_service_name = "your-search-service-name"
endpoint = f"https://{search_service_name}.search.windows.net"

# Use DefaultAzureCredential to authenticate with Managed Identity
credential = DefaultAzureCredential()

# Initialize the Search Index Client
index_client = SearchIndexClient(endpoint=endpoint, credential=credential)

# List all indexes
indexes = index_client.get_indexes()

# Print each index name
for index in indexes:
    print(f"Index name: {index.name}")