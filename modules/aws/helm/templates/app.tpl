---
appEnvironment: ${app_environment}
existingSecret: makor-lavan
fullnameOverride: ${app_name}
ingress:
  enabled: true
  hosts:
    - host: ${host_name}
      paths:
        - path: /
          pathType: ImplementationSpecific
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
