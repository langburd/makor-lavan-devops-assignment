---
verbosityLevel: 4

reconcilePeriodSeconds: 60

kubernetes:
  resources:
    requests:
      cpu: 100m
      memory: 100Mi
  ingressClassResource:
    default: true

appgw:
  environment: AzurePublicCloud
  subscriptionId: ${subscription_id}
  resourceGroup: ${resource_group_name}
  name: ${ingress_application_gateway_name}
  usePrivateIP: false
  shared: false

armAuth:
  type: workloadIdentity
  identityClientID: ${identity_client_id}
