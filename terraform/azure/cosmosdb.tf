resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
  tags = {
    git_commit           = "0d01ed4ac61a22a6d0b8f35d15fa98f5a643f138"
    git_file             = "terraform/azure/cosmosdb.tf"
    git_last_modified_at = "2023-09-07 03:55:09"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "example"
    yor_trace            = "94b7dda0-dfca-46f5-8f02-a3dfd1bc6732"
  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  access_key_metadata_writes_enabled = true

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = "eastus"
    failover_priority = 1
  }

  geo_location {
    location          = "westus"
    failover_priority = 0
  }
  tags = {
    git_commit           = "0d01ed4ac61a22a6d0b8f35d15fa98f5a643f138"
    git_file             = "terraform/azure/cosmosdb.tf"
    git_last_modified_at = "2023-09-07 03:55:09"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "db"
    yor_trace            = "fd8dc038-36c5-4d22-b444-d94b9824761d"
  }
}
