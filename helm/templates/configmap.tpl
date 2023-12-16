apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "makor-lavan.fullname" . }}-index-html
  labels:
    {{- include "makor-lavan.labels" . | nindent 4 }}
data:
{{ (.Files.Glob "index.html").AsConfig | indent 2 }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "makor-lavan.fullname" . }}-env-vars
  labels:
    {{- include "makor-lavan.labels" . | nindent 4 }}
data:
  APP_ENVIRONMENT: {{ .Values.appEnvironment | quote }}
