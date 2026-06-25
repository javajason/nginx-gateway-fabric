# Install NGINX Gateway Fabric - Quickstart

```
JWT_token="<your-jwt-token>"
kubectl create namespace nginx-gateway
k get all -n nginx-gateway
kubectl create secret docker-registry nginx-plus-registry-secret --docker-server=private-registry.nginx.com --docker-username=$JWT_token --docker-password=none -n nginx-gateway
echo $JWT_token > license.jwt
kubectl create secret generic nplus-license --from-file license.jwt -n nginx-gateway
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.6.5" | kubectl apply -f -
kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric  --set nginx.image.repository=private-registry.nginx.com/nginx-gateway-fabric/nginx-plus --set nginx.plus=true --set nginx.imagePullSecret=nginx-plus-registry-secret -n nginx-gateway --set nginx.service.type=NodePort
```

# Confirm installation
`kubectl get all -n nginx-gateway`
