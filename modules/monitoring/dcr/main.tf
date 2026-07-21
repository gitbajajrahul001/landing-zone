resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = var.dcr_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"   # rule is scoped to Linux agent data sources only

  destinations {
    log_analytics {
      name                  = "la"
      workspace_resource_id = var.workspace_resource_id
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["la"]
  }

  data_sources {
    performance_counter {
      name                          = "performance_memory"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = var.sampling_frequency_in_seconds
      counter_specifiers            = var.counters
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_data_collection_rule_association" "assoc" {
  name                     = "${var.dcr_name}-assoc"
  data_collection_rule_id  = azurerm_monitor_data_collection_rule.dcr.id
  target_resource_id       = var.resource_to_associate
}
