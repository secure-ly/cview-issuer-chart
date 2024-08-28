# cview-issuer for cert-manager by Securely ltd 
<p align="center">
  <img src="https://secure-ly.github.io/cview-issuer-chart/logo/1234-logo.png" alt="Securely logo" />
</p>
The C-View issuer is an external certificate issuer for the cert-manager engine <br />
The cview-issuer works through the CVIEW certificate management platform to sign certificate requests in the organization ADCS. 
    
[1. Prerequisites](#1-prerequisites) <br />
[2. Cert-manager installation using helm chart](#2-cert-manager-installation-using-helm-chart)<br />
[3. C-View issuer installation helm cart](#3-cview-issuer-installation-helm-cart)<br />
[4. C-View issuer installation platform](#4-target-platform-installation-commands)<br />
[5. C-View issuer configuration](#5-c-view-issuer-configuration)<br />
        
## 1. Prerequisites 
The following components are required before installing the C-View Issuer 

- Kubernetes cluster with version >=1.27.x      
- Cert manager with version >=1.12.x 
- Jaeger opentracing (optional)
- C-View CLM >= 7.x.x (For more information, contact [Securely LTD](https://www.secure-ly.com/contact-us-securely))

## 2. cert-manager installation using helm chart 
This is the preferred way to use an official cert-manager helm chart.

```console
helm repo add jetstack https://charts.jetstack.io --force-update

helm upgrade  --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.14.2  \
  --set installCRDs=true --set enableCertificateOwnerRef=true
```

Check cert-manager installation 
<pre>
kubectl get pod -n cert-manager
</pre>

<pre>
NAME                                       READY   STATUS    RESTARTS       AGE
cert-manager-cainjector-598d9958f6-fss8l   1/1     Running   0              1m
cert-manager-webhook-7c8c5df7fc-xdjl5      1/1     Running   0              1m
cert-manager-54f9895b8c-w2s2x              1/1     Running   0              1m
</pre>

## 3. CView Issuer installation helm cart 

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
secure-ly/cview-issuer   0.0.34          0.0.34          C-View issuer plugin for cert-manager
</pre>

### Get list of all issuer version
```console
helm search repo cview-issuer
```
<pre>
NAME                    CHART VERSION   APP VERSION  DESCRIPTION
secure-ly/cview-issuer   0.0.34          0.0.34      C-View issuer plugin for cert-manager
</pre>

```console
helm search repo cview-issuer --versions 
```
<pre>
NAME                  	CHART VERSION	APP VERSION	 DESCRIPTION                           
secure-ly/cview-issuer	0.0.33       	0.0.33     	 C-View issuer plugin for cert-manager 
secure-ly/cview-issuer	0.0.34       	0.0.34     	 C-View issuer plugin for cert-manager     
</pre>

## 4. Target platform Installation commands

### Install on Kubernetes 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.34 \
  --set crd.install=true
```
### Install on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.34  \
  --set crd.install=true \
  --set openshift.enabled=true
```
### Customize Installation on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.34 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.34 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing=false \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=true \
  --set crd.install=true
```
NOTE: <br/> 
- Set **controllerManager.arguments.enable-tracing="true"** to enable jaeger tracing 

### Adding support for Openshift routes by cert-manager 
Using route objects on open shift requires the installation of the additional package for extending cert-manager behavior.

```console
helm install openshift-routes -n cert-manager oci://ghcr.io/cert-manager/charts/openshift-routes
```

### Display helm chart status

```console
helm list -n cview-issuer
```
<pre>
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                   APP VERSION
cview-issuer    cview-issuer    1               2024-07-02 17:31:20.172857068 +0200 CEST        deployed        cview-issuer-0.0.34     0.0.34
</pre>

## 5. C-View Issuer Configuration



### C-View Secrets 

#### C-View Issuer Credential 

The C-View issuer requires an application user to operate toward the cView Platform. <br />
This user should be a domain user with access rights to the C-View Platform as a Cert Owner.<br />

- Update the **user name** and **password** parameters in the following YAML file: ([cview-issuer-credentials](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-credentials.yaml))
- Deploy the YAML file to Kubernetes/Openshift 
  
#### C-View Issuer activation key

C-View issuer requires a license key from the C-View platform <br /> 
Contact the C-View administrator to get the license key and encode it to the base64 string. <br />

- Update the **key** parameter in the following YAML file: ([cview-issuer-license-key](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-license-key.yaml))
- Deploy the YAML file to Kubernetes/Openshift

### C-View Issuer objects
The configuration of the C-View issuer object allows the set of all relevant parameters for working with the C-View platform.<br /> 
There are two types of c-view issuers, and you can create multiple issuers for different purposes.  
        
#### C-View Cluster Issuer 
Working in a global scope requires a c-view cluster issuer object. Sample YAML file: ([cview-cluster-issuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/cview-cluster-issuer.yaml))

#### Dedicated C-View Issuer 
Working in a dedicated namespace requires a c-view issuer object. Sample YAML file: ([cview-issuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/cview-issuer.yaml))

### C-View issuer ConfigMap 
The default ConfigMAp name is **cview-issuer-configmap-override**. It is created automatically, and all values are hard-coded 
for flexible control over issuer actions you may deploy the following config map YAML file: ([ConfigMap](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/configMap/configmap.yaml))

### C-View certificates objects

C-View Issuer supports the following certificate types: 

#### Standard certificate/secret 
Use this YAML example to create a certificate object: ([Cert-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/cert-example.yaml)) 

#### Openshift Route Secret 
Use this YAML example to create a certificate for an open shift route: ([OpenShift-rout-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/openShift-routs-example.yaml)) 

#### Ingress Secret 
Use this YAML example to create a certificate for ingress: ([Ingress-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/ingress-example.yaml)) 

#### Documentation

![Version: 0.0.33](https://img.shields.io/badge/Version-0.0.33-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.33](https://img.shields.io/badge/AppVersion-0.0.33-informational?style=flat-square)

[C-View Issuer Github repository](https://github.com/secure-ly/cview-issuer-chart/)

