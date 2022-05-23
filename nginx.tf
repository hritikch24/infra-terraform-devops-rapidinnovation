resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://aws.github.io/eks-charts"
  chart      = "nginxssl"

  set {
    name  = "vpccidr"
    value = module.vpc.vpc_cidr_block
  }

  set {
    name  = "sslcertarn"
    value = local.rapidinnovation_acm
  }
}