{{/*
Expand the name of the chart.
*/}}
{{- define "ssi-accreditation-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ssi-accreditation-controller.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ssi-accreditation-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ssi-accreditation-controller.labels" -}}
helm.sh/chart: {{ include "ssi-accreditation-controller.chart" . }}
{{ include "ssi-accreditation-controller.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ssi-accreditation-controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ssi-accreditation-controller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ssi-accreditation-controller.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ssi-accreditation-controller.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

# source: https://phoenixnap.com/kb/helm-environment-variables
{{- define "helpers.list-env-variables"}}
{{- range $key, $val := .Values.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end}}
{{- end }}

{{/*
Get a nested value from a dict in the the has Values, path and Default defined, from a github issue
https://github.com/helm/helm/issues/5180
*/}}
{{- define "getOrDefault" }}
  {{- $v := .Values }}
  {{- $found := true }}
  {{- range $value := regexSplit "\\." .Path -1 }}
    {{- if hasKey $v $value }}
      {{- $v = get $v $value }}
    {{- else }}
      {{- $found = false }}
    {{- end }}
  {{- end }}
  {{- if eq $found true }}
    {{- $v }}
  {{- else }}
    {{- .Default }}
  {{- end }}
{{- end }}