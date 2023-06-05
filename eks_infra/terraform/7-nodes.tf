resource "aws_iam_role" "nodes" {
  name = "eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private-us-east-1a.id,
    aws_subnet.private-us-east-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["m5.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  labels = {
    role = "general"
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.demo.name
}
data "aws_eks_cluster" "cluster" {
  name = "demo"  # Replace with your EKS cluster name
}
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = "2.9.10"
  namespace  = "demo-app"

  depends_on = [data.aws_eks_cluster_auth.cluster]
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}

resource "helm_release" "istio" {
  name       = "istio"
  repository = "https://charts.helm.sh/stable"
  chart      = "istio-base"
  version    = "1.12.0"

  set {
    name  = "global.hub"
    value = "docker.io/istio"
  }
  set {
    name  = "global.tag"
    value = "1.12.0"
  }
  set {
    name  = "gateways.istio-ingressgateway.type"
    value = "LoadBalancer"
  }

  namespace = "istio-system"
}

resource "helm_release" "kiali" {
  name       = "kiali"
  repository = "https://kiali.org/helm-charts"
  chart      = "kiali-server"
  version    = "1.41.0"

  set {
    name  = "image.tag"
    value = "v1.41"
  }

  namespace = "istio-system"

  depends_on = [helm_release.istio]
}

resource "helm_release" "jaeger" {
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger-operator"
  version    = "3.2.2"

  namespace = "istio-system"

  depends_on = [helm_release.istio]
}

resource "helm_release" "istio-gateway" {
  name       = "istio-gateway"
  repository = "https://charts.helm.sh/stable"
  chart      = "istio-ingress"
  version    = "1.12.0"

  set {
    name  = "global.hub"
    value = "docker.io/istio"
  }
  set {
    name  = "global.tag"
    value = "1.12.0"
  }

  namespace = "istio-system"

  depends_on = [helm_release.istio]
}

resource "helm_release" "vpa" {
  name       = "vpa"
  repository = "https://vertical-pod-autoscaler.github.io/charts"
  chart      = "vertical-pod-autoscaler"
  version    = "0.9.1"

  namespace = "kube-system"

  depends_on = [helm_release.istio]
}




