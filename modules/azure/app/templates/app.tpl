---
appEnvironment: ${app_environment}
existingSecret: makor-lavan
fullnameOverride: ${app_name}
ingress:
  enabled: true
  className: azure-application-gateway
  annotations:
    appgw.ingress.kubernetes.io/health-probe-path: "/index.html"
  hosts:
    - paths: # host: ${host_name}
        - path: /
          pathType: Prefix
volumes:
  - name: index-html
    configMap:
      name: ${app_name}-index-html
  - name: env-vars
    configMap:
      name: ${app_name}-env-vars
volumeMounts:
  - name: index-html
    mountPath: /app/web/
    readOnly: true
