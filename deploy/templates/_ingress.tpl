{{/*
Create the default ingress annotations.
*/}}
{{- define "ctron-drogue.ingress.annotations" -}}
{{- with .ingress.annotations }}
{{- . | toYaml }}
{{- else }}
{{- if eq .root.Values.global.cluster "openshift" }}
route.openshift.io/termination: {{ .termination | default "edge" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the ingressClassName field.
*/}}
{{- define "ctron-drogue.ingress.className" -}}
{{- with .ingress.className | default .root.Values.defaults.ingress.className }}
ingressClassName: {{ . }}
{{- end }}
{{- end }}


{{/*
Service host:
 * root - .
 * insecure - https or not
 * prefix - DNS prefix
*/}}
{{- define "ctron-drogue.ingress.host" -}}
{{- .ingress.host | default ( printf "%s%s" .prefix .root.Values.global.domain ) -}}
{{- end }}


{{/* HTTP Specific */}}

{{/*
Service URL:
 * root - .
 * insecure - https or not
 * prefix - DNS prefix
*/}}
{{- define "ctron-drogue.ingress.url" -}}
{{- include "ctron-drogue.ingress.proto" . -}}
://
{{- include "ctron-drogue.ingress.host" . -}}

{{- $port := .ingress.port | default 443 | toString -}}
{{- /*
  The next line means:
    !( port == 80 && insecure ) || ( port == 443 && !insecure)
*/ -}}
{{- if not (or (and (eq $port "80") .insecure) (and (eq $port "443") (not .insecure )) ) -}}
:{{ $port }}
{{- end }}

{{- end }}

{{/*
Ingress HTTP protocol:
 * root - .
 * insecure - https or not
*/}}
{{- define "ctron-drogue.ingress.proto" -}}
    {{- with .ingress.proto -}}{{ . }}{{- else -}}
    {{- if not ( kindIs "invalid" .insecure ) -}}
        {{- if .insecure -}}http{{- else -}}https{{- end -}}
    {{- else -}}
        {{- if eq .root.Values.global.cluster "openshift" -}}
            https
        {{- else -}}
            http
        {{- end }}
    {{- end }}{{/* end-if defined .insecure */}}
    {{- end }}{{/* end-with .ingress.proto */}}
{{- end }}
