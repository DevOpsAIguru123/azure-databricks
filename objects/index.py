from azure.identity import DefaultAzureCredential
from azure.search.documents import SearchClient

# Azure Search service details
search_service_name = "your-search-service-name"
index_name = "your-index-name"

# Endpoint format
endpoint = f"https://{search_service_name}.search.windows.net"

# Authenticate using DefaultAzureCredential
credential = DefaultAzureCredential()

# Initialize the SearchClient without any 'key' argument
search_client = SearchClient(endpoint=endpoint, index_name=index_name, credential=credential)

# Perform a search operation (you may need an index and data for this part)
search_results = search_client.search("Sample")

for result in search_results:
    print(result)