helm template cview-issuer  charts/cview-issuer  -n cview-issuer  --create-namespace  --values charts/cview-issuer/values.yaml
helm template cview-issuer  charts/cview-issuer  -n cview-issuer  --create-namespace  --values charts/cview-issuer/values.yaml | grep image: 

helm template cview-issuer charts/cview-issuer -n cview-issuer  --create-namespace --values charts/cview-issuer/values.yaml > cview-issuer-all.yaml

kubectl -n cview-issuer apply -f cview-issuer-all.yaml --dry-run=client
kubectl -n cview-issuer apply -f cview-issuer-all.yaml --dry-run=server
kubectl -n cview-issuer apply -f cview-issuer-all.yaml 


kubectl -n cview-issuer delete -f cview-issuer-all.yaml



kubectl -n cview-issuer get pod 

kubectl -n cview-issuer logs deploy/cview-issuer-controller-manager

kubectl -n cert-manager logs deploy/cert-manager


kubectl -n adcs-issuer logs  deploy/adcs-sim-deployment

kubectl apply -f example-install/certiticates/ -n cview-issuer
kubectl apply -f example-install/issusers/  -n cview-issuer
kubectl apply -f example-install/secrets/  -n cview-issuer

kubectl -n cview-issuer get certificate,certificaterequest,secret

kubectl -n cview-issuer get cviewissuer,cviewclusterissuer

# https://www.sslshopper.com/csr-decoder.html

kubectl -n  cview-issuer get certificaterequest  cview-issuer-cert-test1-56s4s  -o jsonpath="{.spec.request}" | base64 -d > openssl.csr
openssl req -in openssl.csr -noout -text
rm openssl.csr


kubectl -n  cview-issuer get certificaterequest -o yaml | grep request:


kubectl -n  cview-issuer get secret cviewissuer-cert-secret-test1 -o jsonpath="{.data.tls\.crt}" | base64 -d > openssl.crt
openssl x509 -in openssl.crt -text -noout
rm openssl.crt

# https://www.sslshopper.com/certificate-decoder.html



kubectl api-resources --api-group=cert-manager.io

kubectl api-resources --api-group=secure-ly.com

