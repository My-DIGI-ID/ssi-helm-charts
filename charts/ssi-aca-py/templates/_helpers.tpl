{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ssi-aca-py.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ssi-aca-py.fullname" -}}
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
{{- define "ssi-aca-py.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ssi-aca-py.labels" -}}
helm.sh/chart: {{ include "ssi-aca-py.chart" . }}
{{ include "ssi-aca-py.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ssi-aca-py.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ssi-aca-py.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ssi-aca-py.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ssi-aca-py.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ssi-aca-py.postgresConfig" -}}
{"url":{{ default (printf "%s-postgresql:5432" .Release.Name) $.Values.postgresql.url | quote }},"wallet_scheme":"DatabasePerWallet"}
{{- end }}
{{- define "ssi-aca-py.postgresCredentials" -}}
{"account":{{ .Values.postgresql.postgresqlUsername  | quote }},"password":{{ .Values.postgresql.postgresqlPassword | urlquery | quote }},"admin_account":{{ .Values.postgresql.postgresqlUsername | quote }},"admin_password":{{ .Values.postgresql.postgresqlPassword | urlquery | quote }}}
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