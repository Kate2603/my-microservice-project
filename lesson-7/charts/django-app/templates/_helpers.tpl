{{- define "django-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "django-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
