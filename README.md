# nginx-gateway-fabric
Demo assets for NGINX Gateway Fabric / Gateway API
NGINX Gateway Fabric documentation: https://docs.nginx.com/nginx-gateway-fabric/

## Prerequisites
- A running Kubernetes cluster
- Admin access and kubectl installed
- A JWT license (either trial or enterprise) for NGINX One

## Steps
- Deploy the Cafe application
  kubectl create -f ... cafe-application.yaml
  Confirm the installation:
  kubectl get pod -n nginx-gateway
- Install NGINX Gateway Fabric
  See installation options here: https://docs.nginx.com/nginx-gateway-fabric/install/
  This should great a gateway class, "ning", with controllerName, "gateway.nginx.org/nginx-gateway-controller", in the nginx-gateway namespace.
  Confirm by running "kubectl get gatewayclass -A"
- Create a gateway resource
  kubectl create -f ... gateway.yaml
  Confirm the installation:
  kubectl get gateway -n nginx-gateway
After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.
- Create the HTTPRoute
  kubectl create -f ... httproute.yaml
  Confirm the installation:
  kubectl get httproute -n nginx-gateway
- 
kubectl get gateway -A
kubectl get httproute -A

- Find the NodePort service port number:
  kubectl get service nginx-gateway

  kubectl get service -n nginx-gateway
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
coffee-svc                 ClusterIP   None             <none>        80/TCP         5m12s
ngf-nginx-gateway-fabric   ClusterIP   10.108.145.117   <none>        443/TCP        4h12m
nginx-gateway-nginx        NodePort    10.111.71.1      <none>        **80:30337/TCP**   19m
tea-svc                    ClusterIP   None             <none>        80/TCP         5m12s

Specifically, look for the service of type "NodePort".
In this example the port number is 30337. Save this port number to an environment variable:
GW_PORT=<port number>

- Get an IP address from one of the nodes
  kubectl get node -o wide
NAME     STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
node01   Ready    <none>          16d   v1.35.1   **10.1.1.4**      <none>        Ubuntu 24.04.3 LTS   6.8.0-85-generic   containerd://2.3.1
node02   Ready    <none>          16d   v1.35.1   **10.1.1.5**      <none>        Ubuntu 24.04.3 LTS   6.8.0-85-generic   containerd://2.3.1
controlplane   Ready    control-plane   16d   v1.35.1   10.1.1.7      <none>        Ubuntu 24.04.3 LTS   6.8.0-85-generic   containerd://2.2.1

Use the IP address from one the worker nodes, node01 or node02. Either will work fine.
In this example, we use the IP address from node01, 10.1.1.4. Save this IP address to an environment variable:

GW_IP=XXX.YYY.ZZZ.III

Now, try out the application:
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
