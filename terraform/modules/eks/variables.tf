variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the control plane"
  type        = string
  default     = "1.31"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes and control plane ENIs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs (tagged for internet-facing load balancers)"
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group (t3.micro is Free Tier–eligible; use t3.medium if your account allows it)"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 6
}

variable "endpoint_public_access" {
  description = "Allow kubectl/API from the internet (homework default: true)"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
