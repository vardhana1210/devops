
This repo contains two folers :
       1.eks_infra : I have created jenkins cicd pipline to deplo eks infra and jenkins file you can find in eks_infra/Jenkinsfile

         jenkins pipline job: http://3.90.41.143:8080/job/eks_infra_deploy/
       2. sample-app: I have created sample app and created jenkins cicd pipline to deploy this sample java app using helm charts , Jenkins file location: sample-app
       jenkins pipline location: http://3.90.41.143:8080/job/demo-app-deploy/
       sample app can be accessble publically on : http://a16087e6e2d8d4def8268e0733846598-1088045849.us-east-1.elb.amazonaws.com/

 I will share temp jenkins credenatils over email to see this jenkins job


I have also deployed prometheus,grafana for monitoring and loki for logging on the cluster and istio for service mesh .
########################################installed pods#########################################
[ec2-user@ip-172-31-20-205 ~]$ kubectl get all -A
NAMESPACE      NAME                                            READY   STATUS    RESTARTS   AGE
demo-app       pod/details-v1-6997d94bb9-b8ghf                 2/2     Running   0          6h25m
demo-app       pod/first-demo-mychart-779fd9b59b-ttlgj         2/2     Running   0          4m17s
demo-app       pod/loki-0                                      1/1     Running   0          7h11m
demo-app       pod/loki-promtail-6mpgl                         1/1     Running   0          7h11m
demo-app       pod/productpage-v1-d4f8dfd97-kv8p4              2/2     Running   0          6h25m
demo-app       pod/ratings-v1-b8f8fcf49-22krh                  2/2     Running   0          6h25m
demo-app       pod/reviews-v1-5896f547f5-qdvz7                 2/2     Running   0          6h25m
demo-app       pod/reviews-v2-5d99885bc9-t27hf                 2/2     Running   0          6h25m
demo-app       pod/reviews-v3-589cb4d56c-r2l4f                 2/2     Running   0          6h25m
istio-system   pod/grafana-69f9b6bfdc-klw9x                    1/1     Running   0          6h33m
istio-system   pod/istio-egressgateway-676bf68b54-h7qff        1/1     Running   0          6h37m
istio-system   pod/istio-ingressgateway-8d56c999d-ldk47        1/1     Running   0          6h37m
istio-system   pod/istiod-dbf5ff64-6xdw7                       1/1     Running   0          6h37m
istio-system   pod/jaeger-cc4688b98-ggn74                      1/1     Running   0          6h33m
istio-system   pod/kiali-594965b98c-kv45m                      1/1     Running   0          6h33m
istio-system   pod/prometheus-5f84bbfcfd-jmkmw                 2/2     Running   0          6h33m
kube-system    pod/aws-node-d9r5l                              1/1     Running   0          8h
kube-system    pod/coredns-55fb5d545d-74hlt                    1/1     Running   0          8h
kube-system    pod/coredns-55fb5d545d-p8qts                    1/1     Running   0          8h
kube-system    pod/kube-proxy-blfl4                            1/1     Running   0          8h
kube-system    pod/vpa-admission-controller-69855c7f6c-5p6xn   1/1     Running   0          11m
kube-system    pod/vpa-recommender-5bcfd5b448-bvxdt            1/1     Running   0          11m
kube-system    pod/vpa-updater-db6fff4fb-9jzmb                 1/1     Running   0          11m

NAMESPACE      NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                                                                      AGE
default        service/kubernetes             ClusterIP      172.20.0.1       <none>                                                                    443/TCP                                                                      8h
demo-app       service/details                ClusterIP      172.20.80.112    <none>                                                                    9080/TCP                                                                     6h25m
demo-app       service/first-demo-mychart     LoadBalancer   172.20.26.213    a16087e6e2d8d4def8268e0733846598-1088045849.us-east-1.elb.amazonaws.com   80:31012/TCP                                                                 7h54m
demo-app       service/loki                   ClusterIP      172.20.12.144    <none>                                                                    3100/TCP                                                                     7h11m
demo-app       service/loki-headless          ClusterIP      None             <none>                                                                    3100/TCP                                                                     7h11m
demo-app       service/loki-memberlist        ClusterIP      None             <none>                                                                    7946/TCP                                                                     7h11m
demo-app       service/productpage            ClusterIP      172.20.60.117    <none>                                                                    9080/TCP                                                                     6h25m
demo-app       service/ratings                ClusterIP      172.20.120.127   <none>                                                                    9080/TCP                                                                     6h25m
demo-app       service/reviews                ClusterIP      172.20.1.207     <none>                                                                    9080/TCP                                                                     6h25m
istio-system   service/grafana                ClusterIP      172.20.14.203    <none>                                                                    3000/TCP                                                                     6h33m
istio-system   service/istio-egressgateway    ClusterIP      172.20.77.19     <none>                                                                    80/TCP,443/TCP                                                               6h37m
istio-system   service/istio-ingressgateway   LoadBalancer   172.20.246.87    a4893ea98ccf8402da046ab1b88c7636-801224318.us-east-1.elb.amazonaws.com    15021:30724/TCP,80:31510/TCP,443:30591/TCP,31400:32104/TCP,15443:31519/TCP   6h37m
istio-system   service/istiod                 ClusterIP      172.20.144.142   <none>                                                                    15010/TCP,15012/TCP,443/TCP,15014/TCP                                        6h37m
istio-system   service/jaeger-collector       ClusterIP      172.20.252.73    <none>                                                                    14268/TCP,14250/TCP,9411/TCP                                                 6h33m
istio-system   service/kiali                  ClusterIP      172.20.122.188   <none>                                                                    20001/TCP,9090/TCP                                                           6h33m
istio-system   service/prometheus             ClusterIP      172.20.96.152    <none>                                                                    9090/TCP                                                                     6h33m
istio-system   service/tracing                ClusterIP      172.20.164.78    <none>                                                                    80/TCP,16685/TCP                                                             6h33m
istio-system   service/zipkin                 ClusterIP      172.20.85.89     <none>                                                                    9411/TCP                                                                     6h33m
kube-system    service/kube-dns               ClusterIP      172.20.0.10      <none>                                                                    53/UDP,53/TCP                                                                8h
kube-system    service/vpa-webhook            ClusterIP      172.20.162.135   <none>                                                                    443/TCP                                                                      11m

NAMESPACE     NAME                           DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
demo-app      daemonset.apps/loki-promtail   1         1         1       1            1           <none>          7h11m
kube-system   daemonset.apps/aws-node        1         1         1       1            1           <none>          8h
kube-system   daemonset.apps/kube-proxy      1         1         1       1            1           <none>          8h

NAMESPACE      NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
demo-app       deployment.apps/details-v1                 1/1     1            1           6h25m
demo-app       deployment.apps/first-demo-mychart         1/1     1            1           7h54m
demo-app       deployment.apps/productpage-v1             1/1     1            1           6h25m
demo-app       deployment.apps/ratings-v1                 1/1     1            1           6h25m
demo-app       deployment.apps/reviews-v1                 1/1     1            1           6h25m
demo-app       deployment.apps/reviews-v2                 1/1     1            1           6h25m
demo-app       deployment.apps/reviews-v3                 1/1     1            1           6h25m
istio-system   deployment.apps/grafana                    1/1     1            1           6h33m
istio-system   deployment.apps/istio-egressgateway        1/1     1            1           6h37m
istio-system   deployment.apps/istio-ingressgateway       1/1     1            1           6h37m
istio-system   deployment.apps/istiod                     1/1     1            1           6h37m
istio-system   deployment.apps/jaeger                     1/1     1            1           6h33m
istio-system   deployment.apps/kiali                      1/1     1            1           6h33m
istio-system   deployment.apps/prometheus                 1/1     1            1           6h33m
kube-system    deployment.apps/coredns                    2/2     2            2           8h
kube-system    deployment.apps/vpa-admission-controller   1/1     1            1           11m
kube-system    deployment.apps/vpa-recommender            1/1     1            1           11m
kube-system    deployment.apps/vpa-updater                1/1     1            1           11m

NAMESPACE      NAME                                                  DESIRED   CURRENT   READY   AGE
demo-app       replicaset.apps/details-v1-6997d94bb9                 1         1         1       6h25m
demo-app       replicaset.apps/first-demo-mychart-5465b76b5f         0         0         0       6h37m
demo-app       replicaset.apps/first-demo-mychart-54c4759868         0         0         0       6h34m
demo-app       replicaset.apps/first-demo-mychart-5cf774c445         0         0         0       6h49m
demo-app       replicaset.apps/first-demo-mychart-6f5b6b9697         0         0         0       5h44m
demo-app       replicaset.apps/first-demo-mychart-6f89fc66bf         0         0         0       7h25m
demo-app       replicaset.apps/first-demo-mychart-76bd7cbfc4         0         0         0       7h19m
demo-app       replicaset.apps/first-demo-mychart-779fd9b59b         1         1         1       4m17s
demo-app       replicaset.apps/first-demo-mychart-795699b66          0         0         0       6h42m
demo-app       replicaset.apps/first-demo-mychart-79cb978dc          0         0         0       7h15m
demo-app       replicaset.apps/first-demo-mychart-899f99c96          0         0         0       7h28m
demo-app       replicaset.apps/first-demo-mychart-9c7859984          0         0         0       7h11m
demo-app       replicaset.apps/productpage-v1-d4f8dfd97              1         1         1       6h25m
demo-app       replicaset.apps/ratings-v1-b8f8fcf49                  1         1         1       6h25m
demo-app       replicaset.apps/reviews-v1-5896f547f5                 1         1         1       6h25m
demo-app       replicaset.apps/reviews-v2-5d99885bc9                 1         1         1       6h25m
demo-app       replicaset.apps/reviews-v3-589cb4d56c                 1         1         1       6h25m
istio-system   replicaset.apps/grafana-69f9b6bfdc                    1         1         1       6h33m
istio-system   replicaset.apps/istio-egressgateway-676bf68b54        1         1         1       6h37m
istio-system   replicaset.apps/istio-ingressgateway-8d56c999d        1         1         1       6h37m
istio-system   replicaset.apps/istiod-dbf5ff64                       1         1         1       6h37m
istio-system   replicaset.apps/jaeger-cc4688b98                      1         1         1       6h33m
istio-system   replicaset.apps/kiali-594965b98c                      1         1         1       6h33m
istio-system   replicaset.apps/prometheus-5f84bbfcfd                 1         1         1       6h33m
kube-system    replicaset.apps/coredns-55fb5d545d                    2         2         2       8h
kube-system    replicaset.apps/vpa-admission-controller-69855c7f6c   1         1         1       11m
kube-system    replicaset.apps/vpa-recommender-5bcfd5b448            1         1         1       11m
kube-system    replicaset.apps/vpa-updater-db6fff4fb                 1         1         1       11m

NAMESPACE   NAME                    READY   AGE
demo-app    statefulset.apps/loki   1/1     7h11m

NAMESPACE   NAME                                                     REFERENCE                       TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
demo-app    horizontalpodautoscaler.autoscaling/first-demo-mychart   Deployment/first-demo-mychart   <unknown>/80%   1         100       1          7h54m
[ec2-user@ip-172-31-20-205 ~]$
[ec2-user@ip-172-31-20-205 ~]$ kubectl get vpa -n demo-app
NAME           MODE   CPU   MEM   PROVIDED   AGE
demo-app-vpa                                 6m29s
[ec2-user@ip-172-31-20-205 ~]$





 