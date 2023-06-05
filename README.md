# devops demo app deployed

istio insallation steps:
 curl -L https://istio.io/downloadIstio | sh -
cd istio-1.17.2/
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
kubectl label namespace demo-app istio-injection=enabled
kubectl label namespace kube-system istio-injection=enabled
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
 