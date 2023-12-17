# https://github.com/aws/eks-charts/blob/a644fd925ca091d881b3a42aace268322f484455/stable/aws-load-balancer-controller/values.yaml

replicaCount: 1
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: ${role_arn}
  name: aws-load-balancer-controller
resources:
  requests:
    cpu: 100m
    memory: 128Mi
podAnnotations:
  eks.amazonaws.com/role-arn: ${role_arn}
clusterName: ${cluster_name}
