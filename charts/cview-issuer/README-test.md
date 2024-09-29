helm template cview-issuer  charts/cview-issuer  -n cview-issuer  --create-namespace  --values charts/cview-issuer/values.yaml
helm template cview-issuer  charts/cview-issuer  -n cview-issuer  --create-namespace  --values charts/cview-issuer/values.yaml | grep image: 

helm template cview-issuer charts/cview-issuer -n cview-issuer  --create-namespace --values charts/cview-issuer/values.yaml > cview-issuer-all.yaml

kubectl -n cview-issuer apply -f cview-issuer-all.yaml --dry-run=client
kubectl -n cview-issuer apply -f cview-issuer-all.yaml --dry-run=server
kubectl -n cview-issuer apply -f cview-issuer-all.yaml 

kubectl -n cview-issuer delete -f cview-issuer-all.yaml


helm-docs


kubectl -n cview-issuer get pod 

kubectl -n cview-issuer logs deploy/cview-issuer-controller-manager

kubectl -n cert-manager logs deploy/cert-manager



kubectl apply -f example-install/certiticates/ -n cview-issuer
kubectl apply -f example-install/issusers/  -n cview-issuer
kubectl apply -f example-install/secrets/  -n cview-issuer

kubectl -n cview-issuer get certificate,certificaterequest,secret

kubectl -n cview-issuer get cviewissuer,cviewclusterissuer


kubectl -n  cview-issuer get certificaterequest -o yaml | grep request:


kubectl -n  cview-issuer get secret cviewissuer-cert-secret-test1 -o jsonpath="{.data.tls\.crt}" | base64 -d > openssl.crt
openssl x509 -in openssl.crt -text -noout
rm openssl.crt

# https://www.sslshopper.com/certificate-decoder.html



kubectl api-resources --api-group=cert-manager.io

kubectl api-resources --api-group=secure-ly.com




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
  --set openshift.enabled=false \
  --set crd.install=true \
  --set configmap.install=false \
  --set cert-manager.enabled=true \
  --set cert-manager.namespace=cert-manager  \
  --set cert-manager.crds.enabled=true \
  --dry-run 


helm uninstall cert-manager -n cert-manager


release "cert-manager" uninstalled





helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.34 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.34 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=false \
  --set crd.install=true \
  --set configmap.install=false \
  --set cert-manager.enabled=false \
  --set cert-manager.namespace=cert-manager  \
  --set cert-manager.crds.enabled=true \
  --dry-run 




helm upgrade --install \
  cview-issuer secure-ly/cview-issuer \
  --namespace cview-issuer \
  --create-namespace \
  --version 0.0.34 \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.34 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=false \
  --set crd.install=true \
  --set configmap.install=false \
  --set cert-manager.enabled=false \
  --set cert-manager.namespace=cert-manager  \
  --set cert-manager.crds.enabled=true \
  --dry-run 




helm template cview-issuer charts/cview-issuer -n cview-issuer  --create-namespace --values charts/cview-issuer/values.yaml --set crd.install=false  \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.34 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=false \
  --set cert-manager.enabled=true \
  --set cert-manager.namespace=cert-manager  \
  --set cert-manager.crds.enabled=false > cview-issuer-all.yaml



  helm template cview-issuer charts/cview-issuer -n cview-issuer  --create-namespace --values charts/cview-issuer/values.yaml --set crd.install=false  \
  --set controllerManager.manager.image.repository=devsecurely/cview-issuer \
  --set controllerManager.manager.image.tag=0.0.34 \
  --set controllerManager.arguments.cluster-resource-namespace=cview-issuer \
  --set controllerManager.arguments.enable-tracing="false" \
  --set controllerManager.arguments.tracing-endpoint="jaeger-collector.jaeger-operator.svc.cluster.local:4318" \
  --set openshift.enabled=false \
  --set cert-manager-1-14.enabled=true \
  --set cert-manager-1-14.namespace=cert-manager  \
  --set cert-manager-1-14.crds.enabled=false > cview-issuer-all.yaml