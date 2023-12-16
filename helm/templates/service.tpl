apiVersion: v1
kind: Service
metadata:
  name: {{ include "makor-lavan.fullname" . }}
  labels:
    {{- include "makor-lavan.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "makor-lavan.selectorLabels" . | nindent 4 }}
