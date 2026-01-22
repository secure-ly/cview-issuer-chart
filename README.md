<p align="center">
 <a href="https://www.secure-ly.com"><img src="logo/1234-logo.jpg" alt="Securely logo" /></a>
</p>

# cview-issuer for cert-manager by Securely LTD

The C-View issuer is known cert-manager issuer [Issuers](https://cert-manager.io/docs/configuration/issuers). <br /> 
It operates through the C-VIEW certificate management platform to process certificate requests within  <br />
the organization's ADCS and supports public certificate authorities like GlobalSign and DigiCert.
    
[1. Prerequisites](#1-prerequisites) <br />
[2. Cert-manager installation using helm chart](#2-cert-manager-installation-using-helm-chart)<br />
[3. C-View issuer installation helm cart](#3-cview-issuer-installation-helm-cart)<br />
[4. C-View issuer installation platform](#4-target-platform-installation-commands)<br />
[5. C-View issuer configuration](#5-c-view-issuer-configuration)<br />
        
## 1. Prerequisites 
The following components are required before installing the C-View Issuer 

- Kubernetes cluster with version >=1.29.x      
- Cert manager with version >=1.18.x   (For list of supported versions: [Supported versions](https://cert-manager.io/docs/releases/))  
- Jaeger opentracing (optional)
- C-View CLM >= 7.1.x (For more information, contact [Securely LTD](https://www.secure-ly.com/contact-us-securely))

## 2. Cert-manager installation using helm chart 
This is the preferred way to install cert-manager via helm-chart

###  Add jetstack to helm chart repository support 
```console
helm repo add jetstack https://charts.jetstack.io --force-update
```
###  Install cert-manager (vanila) 
```console
helm upgrade  --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.18.3  \
  --set crds.enabled=true \
  --set enableCertificateOwnerRef=true
```
### Adding support for Gateway API in kubernetes
``` consol
kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
```
###  Install cert-manager with GatewayAPI Enabled (optional) 
```console
helm upgrade  --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.18.3  \
  --set config.enableGatewayAPI=true \
  --set config.apiVersion="controller.config.cert-manager.io/v1alpha1" \
  --set config.kind="ControllerConfiguration" \
  --set crds.enabled=true \
  --set enableCertificateOwnerRef=true
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

### Adding support for Openshift routes by cert-manager 
Using route objects on open shift requires installing the additional package to extend cert-manager behavior.

```console
helm install openshift-routes -n cert-manager oci://ghcr.io/cert-manager/charts/openshift-routes
```

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
secure-ly/cview-issuer   0.0.40          0.0.40          C-View issuer plugin for cert-manager
</pre>

### Get a list of all issuer version
```console
helm search repo cview-issuer
```
<pre>
NAME                    CHART VERSION   APP VERSION  DESCRIPTION
secure-ly/cview-issuer   0.0.40          0.0.40      C-View issuer plugin for cert-manager
</pre>

```console
helm search repo cview-issuer --versions 
```
<pre>
NAME                  	CHART VERSION	APP VERSION	 DESCRIPTION                           
secure-ly/cview-issuer	0.0.38       	0.0.38     	 C-View issuer plugin for cert-manager     
secure-ly/cview-issuer	0.0.39       	0.0.39     	 C-View issuer plugin for cert-manager     
secure-ly/cview-issuer	0.0.40       	0.0.40     	 C-View issuer plugin for cert-manager     
</pre>

## 4. Target platform Installation commands

### Install on Kubernetes 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.40 \
  --set controllerManager.manager.image.tag=0.0.41 \
  --set crd.install=true
```
### Install on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.40  \
  --set controllerManager.manager.image.tag=0.0.41 \
  --set crd.install=true \
  --set openshift.enabled=true \
  --set openshift.anyuid=true
```
### Customize Installation on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.40 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.41 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set openshift.enabled=true \
  --set openshift.anyuid=false \
  --set crd.install=true
```
NOTE: <br/> 
- Set **controllerManager.arguments.enable-tracing="true"** to enable jaeger tracing
- Setting **openshift.anyuid** parameter to **false** will create a security context constraint. See example ([security-context-constraint](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/security/openshitf-rbac.yaml))  

### Display helm chart status

```console
helm list -n cview-issuer
```
<pre>
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                   APP VERSION
cview-issuer    cview-issuer    1               2025-12-05 10:31:20.172857068 +0200 CEST        deployed        cview-issuer-0.0.40     0.0.40
</pre>

## 5. C-View Issuer Configuration

### 5.1 C-View Secrets 

#### 5.1.1 C-View Issuer Credential 

The C-View issuer supports both basic and token-based authentication to operate toward the C-View Platform <br />
**Starting C-View platform version 7.3.0 it's required to set the authMethod to 'token' **. <br /> 

- authMethod property
  - set to **basic** for basic authentication and update the **user name** and **password** parameters (**From C-View 7.3.0 it's not supported**) 
  - set to **token** for token-based authentication and update the **token** value (get the token form C-View administrator)

- Credintial YAML file example: ([cview-issuer-credentials](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-credentials.yaml))
- Deploy the YAML file to Kubernetes/Openshift 

#### 5.1.2 C-View Issuer activation key

C-View issuer requires a license key from the C-View platform <br /> 
Contact the C-View administrator to get the license key and encode it to the base64 string. <br />

- Update the **key** parameter in the following YAML file: ([cview-issuer-license-key](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-license-key.yaml))
- Deploy the YAML file to Kubernetes/Openshift

### 5.2 C-View Issuer objects
The configuration of the C-View issuer object allows the set of all relevant parameters for working with the C-View platform.<br /> 
There are two types of c-view issuers, and you can create multiple issuers for different purposes.  
        
#### 5.2.1 C-View Cluster Issuer 
Working in a global scope requires a c-view cluster issuer object. Sample YAML file: ([cview-cluster-issuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/cview-cluster-issuer.yaml))

#### 5.2.2 Dedicated C-View Issuer 
Working in a dedicated namespace requires a c-view issuer object. Sample YAML file: ([cview-issuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/cview-issuer.yaml))

### 5.3 C-View issuer ConfigMap 
The default ConfigMAp name is **cview-issuer-configmap-override**. It is created automatically, and all values are hard-coded 
for flexible control over issuer actions you may deploy the following config map YAML file: ([ConfigMap](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/configMap/configmap.yaml))

### 5.4 C-View certificates objects

C-View Issuer supports the following certificate types: 

#### 5.4.1 Standard certificate/secret 
Use this YAML example to create a certificate object: ([Cert-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/cert-example.yaml)) 

#### 5.4.1.1 Standard certificate/secret as JKS or PFX 
Use this YAML to create the secrte of the JKS /PFX : ([cert-store-secret](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cert-store-secret.yaml)) <br /> 
Use this YAML example to create a certificate object with JKS or PFX : ([cert-store-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/cert-store-example.yaml)) 

#### 5.4.2 Openshift Route Secret 
Use this YAML example to create a certificate for an open shift route: ([OpenShift-rout-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/openShift-routs-example.yaml))<br />
<b>Unused annotations should be excluded or commented from the yaml file</b>

#### 5.4.3 Ingress Secret 
Use this YAML example to create a certificate for ingress: ([Ingress-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/ingress-example.yaml)) <br />
<b>Unused annotations should be excluded or commented from the yaml file</b>

#### 5.4.4 GetWay API Secret 
Use this YAML example to create a certificate for cert manager get way API : ([getway-api-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/gate-way-api.yaml)) <br />
<b>Unused annotations should be excluded or commented from the yaml file</b>

#### Documentation


[C-View Issuer Github repository](https://github.com/secure-ly/cview-issuer-chart/)









