{{/*
Return the chart name.
*/}}
{{- define "omeka.name" -}}
omeka
{{- end }}

{{/*
Return the full name.
*/}}
{{- define "omeka.fullname" -}}
{{- printf "%s-omeka" .Release.Name -}}
{{- end }}
