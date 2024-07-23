[Github repository](https://github.com/secure-ly/cview-issuer-chart/)
# Install cview-issuer via helm chart

- [1. Prerequisites](#1-prerequisites)
- [2. C-View Issuer installation using helm cart](#2-CView-Issuer-installation-using-helm-cart)
    - [Add repository](#Add-cview-issuer-helm-chart-repository)
    - [Update to the latest version](#Update-to-the-latest-version)
    - [List issuer versions](#Get-list-of-all-issuer-version)
    - [Install commands](#Install-commands)
        - [Install on kubernetes](#install-on-kubernetes)
        - [Install on Openshift](#install-on-openshift)
        - [Install with customization](#install-with-customization)
  - [Show helm chart status](#show-helm-chart-status)
  - [Cert manager and route objects](#cert-manager-and-route-objects)
  - [Documentation](#documentation)
    - [Values](#values)
    
## 1. Prerequisites 

C-View Issuer prerequisites are the following components installed.

- Kubernetes cluster with version >=1.27.x      
- Cert manager with version >=1.12.x    
- Jaeger opentracing (optional)

## 2. CView Issuer installation using helm cart 

### Add cview-issuer helm chart repository
```console
helm repo add secure-ly https://secure-ly.github.io/cview-issuer-chart/ --force-update
```

### Update to the latest version 
```console
helm repo update secure-ly
```
<pre>
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
secure-ly/cview-issuer   0.0.32          0.0.32          C-View issuser plugin for cert-manager
</pre>

### Get list of all issuer version
```console
helm search repo cview-issuer
```
<pre>
NAME                    CHART VERSION   APP VERSION  DESCRIPTION
secure-ly/cview-issuer   0.0.30          0.0.30      C-View issuser plugin for cert-manager
secure-ly/cview-issuer   0.0.29          0.0.29      C-View issuser plugin for cert-manager
</pre>

```console
helm search repo cview-issuer --versions 
```
<pre>
NAME                  	CHART VERSION	APP VERSION	 DESCRIPTION                           
secure-ly/cview-issuer	0.0.30       	0.0.30     	 C-View issuer plugin for cert-manager 
secure-ly/cview-issuer	0.0.31       	0.0.31     	 C-View issuer plugin for cert-manager     
secure-ly/cview-issuer	0.0.32       	0.0.32     	 C-View issuer plugin for cert-manager 
</pre>

### Install commands:

#### Install on kubernetes 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.32 \
  --set crd.install=true
```

#### Install on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.32  \
  --set crd.install=true \
  --set openshift.enabled=true

```

#### Install with customization 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.32 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.33 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=true \
  --set crd.install=true
```

## Show helm chart status

```console
helm list -n cview-issuer
```
<pre>
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                   APP VERSION
cview-issuer    cview-issuer    1               2024-07-02 17:31:20.172857068 +0200 CEST        deployed        cview-issuer-0.0.32     0.0.32
</pre>

## Openshift routes (for cert-manager)

Using route objects on openshift requires the installation of additional package for extending cert-manager behavior.

```console
helm install openshift-routes -n cert-manager oci://ghcr.io/cert-manager/charts/openshift-routes
```

## Documentation


![Version: 0.0.30](https://img.shields.io/badge/Version-0.0.30-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.30](https://img.shields.io/badge/AppVersion-0.0.30-informational?style=flat-square)

C-View issuser plugin for cert-manager

### Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controllerManager.annotations.app | string | `"cview-issuer"` |  |
| controllerManager.arguments.cluster-resource-namespace | string | `"cview-issuer"` |  |
| controllerManager.arguments.enable-tracing | string | `"true"` |  |
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
| controllerManager.manager.image.tag | string | `"0.0.32"` |  |
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
| openshift.anyuid | bool | `true` |  |
| openshift.enabled | bool | `true` |  |
| webhookService.ports[0].port | int | `443` |  |
| webhookService.ports[0].targetPort | int | `9443` |  |
| webhookService.type | string | `"ClusterIP"` |  |
