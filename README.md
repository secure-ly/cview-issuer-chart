# cview-issuer for cert-manager 

C-View issuer is an external certificate issuers for cert-manager engine <br />
The cview-issuer works through the CVIEW certificate management platform to sign certificate request in the organization ADCS 
    
[1. Prerequisites](#1-prerequisites) <br />
[2. C-View issuer installation helm cart](#2-cview-issuer-installation-helm-cart)<br />
[3. C-View issuer installation platform](#3-target-platform-installation-commands)<br />
[4. C-View issuer configuration](#4-c-view-issuer-configuration)<br />
        
## 1. Prerequisites 
The following components are required befroe installaing C-View Issuer 

- Kubernetes cluster with version >=1.27.x      
- Cert manager with version >=1.12.x 
- Jaeger opentracing (optional)
- C-View CLM >= 7.x.x (For more information contact [Securely LTD](https://www.secure-ly.com/contact-us-securely)) 

## 2. CView Issuer installation helm cart 

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

## 3. Target platform Installation commands

### Install on kubernetes 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.33 \
  --set crd.install=true
```
### Install on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.33  \
  --set crd.install=true \
  --set openshift.enabled=true
```
### Customize Installation on Openshift 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.33 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.33 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=true \
  --set crd.install=true
```

### Customize Installation on Openshift plus cert-manager as dependency component 

```console
helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.33 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.33 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=true \
  --set crd.install=true \
  --set cert-manager.enabled=false \    
  --set cert-manager.namespace=cert-manager 
```

NOTE: <br/> 
- Set **set cert-manager.enabled=true** if you plan to install cview-issuer and cert-manager via helm chart
- Set **controllerManager.arguments.enable-tracing="true"** to enable jaeger tracing 

### Adding support for Openshift routes by cert-manager 
Using route objects on openshift requires the installation of additional package for extending cert-manager behavior.

```console
helm install openshift-routes -n cert-manager oci://ghcr.io/cert-manager/charts/openshift-routes
```

### Display helm chart status

```console
helm list -n cview-issuer
```
<pre>
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART                   APP VERSION
cview-issuer    cview-issuer    1               2024-07-02 17:31:20.172857068 +0200 CEST        deployed        cview-issuer-0.0.32     0.0.32
</pre>

## 4. C-View Issuer Configuration

### C-View Secrets 

#### C-View Issuer Credential 

The C-View issuer requirs an application user  to operate toword cView Platform. <br />
This user should be a domain user with access rights to C-View Platform as a Cert Owner.<br />

- Update the **user name** and **password** parameters in the follwoing YAML file: ([cview-issuer-credentials](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-credentials.yaml))
- Deyploy the YAML file to kubernetes / openshift 
  
#### C-View Issuer activation key

C-View issuer requires a license key from the C-View platform <br /> 
Contact C-View Administrator to get the license key and encode it to base 64 string. <br />

- Update the **key** parameter in the follwoing YAML file: ([cview-issuer-license-key](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/secrets/cview-issuer-license-key.yaml))
- Deyploy the YAML file to kubernetes / openshift

### C-View Issuer objects
The configuration of the C-View issuer object allows the set of all relevant parameters for working with the C-View platform.<br /> 
There are two types of c-view issuers, and you can create multiple issuers for different purposes.  
        
#### C-View Cluster Issuer 
Working in a global namespace requires a c-view cluster issuer object.<br /> 
A sample of YAML file: ([CViewClusterIssuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/CViewClusterIssuer.yaml))

#### Dedicated C-View Issuer 
Working in a dedicated namespace requires a c-view issuer object. <br />
A sample of YAML file: ([CViewIssuer](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/issuers/CViewIssuer.yaml))

### C-View certificates objects

#### Standard certificate/secret 
A sample of YAML file: ([Cert-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/cert-example.yaml)) 

#### Openshift rout Secret 
A sample of YAML file: ([OpenShift-rout-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/openShift-routs-example.yaml)) 

#### ingress Secret 
A sample of YAML file: ([OpenShift-rout-example](https://github.com/secure-ly/cview-issuer-chart/tree/main/examples/certificates/ingress-example.yaml)) 


#### Documentation

![Version: 0.0.33](https://img.shields.io/badge/Version-0.0.33-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.33](https://img.shields.io/badge/AppVersion-0.0.33-informational?style=flat-square)

[C-View Issuer Github repository](https://github.com/secure-ly/cview-issuer-chart/)

