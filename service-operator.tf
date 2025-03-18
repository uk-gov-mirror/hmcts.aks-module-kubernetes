resource "azurerm_federated_identity_credential" "service_operator_credential" {
  name                      = "${var.project}-${var.environment}-${var.cluster_number}-${var.service_shortname}"
  resource_group_name       = var.resource_group_name
  issuer                    = azurerm_kubernetes_cluster.kubernetes_cluster.oidc_issuer_url
  audience                  = ["api://AzureADTokenExchange"]
  parent_id                 = var.aks_mi
  subject                   = "system:serviceaccount:azureserviceoperator-system:azureserviceoperator-default"
}