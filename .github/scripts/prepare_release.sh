#!/bin/bash
set -u 
set -e 

kubernetes_version=1.27.x
cert_manager_version=v1.14.2


helm repo  add secure-ly  https://secure-ly.github.io/cview-issuer-chart/ --force-update
helm search repo secure-ly/cview-issuer

chart_version=0.0.35
app_version=0.0.35

chart_version=$(helm search repo secure-ly/cview-issuer |tail -n 1 |awk '{print $2}')
app_version=$(helm search repo secure-ly/cview-issuer |tail -n 1 |awk '{print $3}')
image_version=0.0.35
image_version=$(helm show values https://github.com/secure-ly/cview-issuer-chart/releases/download/cview-issuer-0.0.35/cview-issuer-0.0.35.tgz | grep tag: | awk '{print $2}')


sed -i "s/{{KUBERNETES_VERSION}}/$kubernetes_version/g" README-RELEASE.md
sed -i "s/{{CHART_VERSION}}/$chart_version/g" README-RELEASE.md
sed -i "s/{{APP_VERSION}}/$app_version/g" README-RELEASE.md
sed -i "s/{{IMAGE_VERSION}}/$image_version/g" README-RELEASE.md
sed -i "s/{{CERT_MANAGER_VERSION}}/$cert_manager_version/g" README-RELEASE.md

echo "kubernetes_version: $kubernetes_version"
echo "cert_manager_version: $cert_manager_version"
echo "chart_version: $chart_version"
echo "app_version: $app_version"
echo "image_version: $image_version"




