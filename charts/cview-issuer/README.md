# cview-issuer

![Version: 0.0.38](https://img.shields.io/badge/Version-0.0.38-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.38](https://img.shields.io/badge/AppVersion-0.0.38-informational?style=flat-square)

C-View issuer plugin for cert-manager

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.jetstack.io | cert-manager(cert-manager) | ~v1.17.2 |
| https://charts.jetstack.io | cert-manager-1-16(cert-manager) | ~v1.16.4 |
| https://charts.jetstack.io | cert-manager-1-15(cert-manager) | ~v1.15.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cert-manager-1-15.enabled | bool | `false` |  |
| cert-manager-1-16.enabled | bool | `false` |  |
| cert-manager.enabled | bool | `false` |  |
| cert-manager.namespace | string | `"cert-manager"` |  |
| configmap.install | bool | `false` |  |
| controllerManager.annotations.app | string | `"cview-issuer"` |  |
| controllerManager.arguments.cluster-resource-namespace | string | `"cview-issuer"` |  |
| controllerManager.arguments.enable-tracing | string | `"false"` |  |
| controllerManager.arguments.leader-elect | string | `"true"` |  |
| controllerManager.arguments.max-concurrent-reconciles | int | `1` |  |
| controllerManager.arguments.tracing-endpoint | string | `"jaeger-collector.jaeger-operator.svc.cluster.local:4318"` |  |
| controllerManager.arguments.zap-log-level | int | `1` |  |
| controllerManager.caCertsSecretName | string | `"ca-certificates"` |  |
| controllerManager.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| controllerManager.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| controllerManager.containerSecurityContext.readOnlyRootFilesystem | bool | `true` |  |
| controllerManager.enabledCaCerts | bool | `false` |  |
| controllerManager.enabledWebHooks | bool | `false` |  |
| controllerManager.environment.ENABLE_DEBUG | string | `"false"` |  |
| controllerManager.environment.ENABLE_WEBHOOKS | string | `"false"` |  |
| controllerManager.environment.KUBERNETES_CLUSTER_DOMAIN | string | `"cluster.local"` |  |
| controllerManager.labels | object | `{"app":"cview-issuer"}` | labels for the controller deployment  |
| controllerManager.manager.image.repository | string | `"devsecurely/cview-issuer"` |  |
| controllerManager.manager.image.tag | string | `"0.0.38"` |  |
| controllerManager.manager.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| controllerManager.manager.livenessProbe.httpGet.port | int | `8081` |  |
| controllerManager.manager.livenessProbe.httpGet.scheme | string | `"HTTP"` |  |
| controllerManager.manager.livenessProbe.periodSeconds | int | `10` |  |
| controllerManager.manager.livenessProbe.timeoutSeconds | int | `10` |  |
| controllerManager.manager.readinessProbe.httpGet.path | string | `"/readyz"` |  |
| controllerManager.manager.readinessProbe.httpGet.port | int | `8081` |  |
| controllerManager.manager.readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| controllerManager.manager.readinessProbe.initialDelaySeconds | int | `10` |  |
| controllerManager.manager.readinessProbe.periodSeconds | int | `20` |  |
| controllerManager.manager.readinessProbe.timeoutSeconds | int | `20` |  |
| controllerManager.manager.resources.limits.cpu | string | `"200m"` |  |
| controllerManager.manager.resources.limits.memory | string | `"500Mi"` |  |
| controllerManager.manager.resources.requests.cpu | string | `"100m"` |  |
| controllerManager.manager.resources.requests.memory | string | `"100Mi"` |  |
| controllerManager.podSecurityContext.fsGroup | int | `1000` |  |
| controllerManager.podSecurityContext.runAsUser | int | `1000` |  |
| controllerManager.rbac.certManagerNamespace | string | `"cert-manager"` |  |
| controllerManager.rbac.certManagerServiceAccountName | string | `"cert-manager"` |  |
| controllerManager.rbac.enabled | bool | `true` |  |
| controllerManager.rbac.serviceAccountName | string | `"cview-issuer"` |  |
| controllerManager.replicaCount | int | `1` |  |
| controllerManager.strategy.type | string | `"Recreate"` |  |
| crd.install | bool | `true` |  |
| metricsService.enabled | bool | `true` |  |
| metricsService.ports[0].name | string | `"https"` |  |
| metricsService.ports[0].port | int | `8443` |  |
| metricsService.ports[0].targetPort | string | `"https"` |  |
| metricsService.type | string | `"ClusterIP"` |  |
| nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| openshift.anyuid | bool | `false` |  |
| openshift.enabled | bool | `false` |  |
| webhookService.ports[0].port | int | `443` |  |
| webhookService.ports[0].targetPort | int | `9443` |  |
| webhookService.type | string | `"ClusterIP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
