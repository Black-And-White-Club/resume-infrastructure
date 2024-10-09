{{- define "servicemonitor.yaml" -}}
{{- if .Values.serviceMonitors }}
{{- range $name, $config := .Values.serviceMonitors }}
{{- if $config.enabled }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ $name }}
  namespace: {{ $config.namespace }}
  labels:
    {{- if $config.labels }}
    {{- toYaml $config.labels | nindent 8 }}
    {{- end }}
spec:
  {{- if $config.namespaceSelector }}
  namespaceSelector:
    {{- toYaml $config.namespaceSelector | nindent 6 }}
  {{- end }}
  selector:
    {{- toYaml $config.selector | nindent 6 }}
  endpoints:
    {{- toYaml $config.endpoints | nindent 6 }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
