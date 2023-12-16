output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "add_kubeconfig" {
  description = "Command to add the EKS cluster to your kubeconfig"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.this.name}"
}
