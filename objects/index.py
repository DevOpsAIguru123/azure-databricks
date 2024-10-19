from azure.identity import DefaultAzureCredential
from azure.search.documents.indexes import SearchIndexClient
from azure.search.documents.indexes.models import SearchIndex, SimpleField, SearchFieldDataType

# Set up your Azure Search service details
search_service_name = "your-search-service-name"
endpoint = f"https://{search_service_name}.search.windows.net"

# Use DefaultAzureCredential to authenticate with Managed Identity
credential = DefaultAzureCredential()

# Initialize the Index Client
index_client = SearchIndexClient(endpoint=endpoint, credential=credential)

# Define the fields (schema) of the index
fields = [
    SimpleField(name="id", type=SearchFieldDataType.String, key=True),
    SimpleField(name="name", type=SearchFieldDataType.String, searchable=True),
    SimpleField(name="description", type=SearchFieldDataType.String, searchable=True)
]

# Create the index
index = SearchIndex(name="my-sample-index", fields=fields)
index_client.create_index(index)

print("Index created successfully.")