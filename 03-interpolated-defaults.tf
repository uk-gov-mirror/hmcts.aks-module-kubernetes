data "azurerm_client_config" "current" {}
data "azurerm_subscription" "subscription" {}

data "azurerm_role_definition" "builtin_role_definition" {
  name  = "Contributor"
  scope = data.azurerm_subscription.subscription.id # /subscriptions/00000000-0000-0000-0000-000000000000
}

data "null_data_source" "tag_defaults" {
  inputs = {
    Project_Name         = var.tag_project_name
    Environment          = var.tag_environment
    Cost_Center          = var.tag_cost_center
    Service              = var.tag_service
    App_Operations_Owner = var.tag_app_operations_owner
    System_Owner         = var.tag_system_owner
    Budget_Owner         = var.tag_budget_owner
    Created_By           = "Terraform"
  }
}

locals {
  slug_location = lower(replace(var.location, " ", "."))
}

data "azurerm_subnet" "dmz" {
  name = format("%s_dmz_%s",
    var.network_shortname,
    var.deploy_environment
  )

  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_subnet" "public" {
  name = format("%s_public_%s",
    var.network_shortname,
    var.deploy_environment
  )

  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_subnet" "private" {
  name = format("%s_private_%s",
    var.network_shortname,
    var.deploy_environment
  )

  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_subnet" "application_gateway" {
  name = format("%s_application_gateway_%s",
    var.network_shortname,
    var.deploy_environment
  )

  virtual_network_name = var.network_name
  resource_group_name  = var.network_resource_group_name
}

data "azurerm_key_vault" "hmcts_access_vault" {
  name                = var.hmcts_access_vault
  resource_group_name = "genesis_resource_group"
}

data "azurerm_key_vault_secret" "kubernetes_aad_client_app_id" {
  name         = "kubernetes-aad-client-app-id"
  key_vault_id = data.azurerm_key_vault.hmcts_access_vault.id
}

data "azurerm_key_vault_secret" "kubernetes_aad_tenant_id" {
  name         = "kubernetes-aad-tenant-id"
  key_vault_id = data.azurerm_key_vault.hmcts_access_vault.id
}

data "azurerm_key_vault_secret" "kubernetes_aad_server_app_id" {
  name         = "kubernetes-aad-server-app-id"
  key_vault_id = data.azurerm_key_vault.hmcts_access_vault.id
}

data "azurerm_key_vault_secret" "kubernetes_aad_server_app_secret" {
  name         = "kubernetes-aad-server-app-secret"
  key_vault_id = data.azurerm_key_vault.hmcts_access_vault.id
}
