## nginx configuration
## Ref: https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/nginx-configuration/index.md
controller:
  config:
    use-proxy-protocol: "true"
  service:
    enabled: true
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "3600"
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'
      service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ${certificate_arn}
      service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy: "ELBSecurityPolicy-TLS-1-2-2017-01"
      service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
    targetPorts:
      http: http
      https: http
