variable "name" {
  description = "Name to assign to the DC/OS cluster."
  default = "dcos-test"
}

variable "trusted_cidr" {
  description = "Administrative CIDR block to whitelist."
}

variable "master_count" {
  description = "Number of master nodes to create."
  default = "1"
}

variable "agent_public_count" {
  description = "Number of public agent nodes to create."
  default = "1"
}

variable "agent_count" {
  description = "Number of agent nodes to create."
  default = "1"
}

variable "region" {
  description = "AWS region to launch into."
  default = "us-east-1"
}

variable "ami" {
  description = "CoreOS AMI to use."
  default = "ami-4d795c5a"
}

variable "bootstrap_instance_type" {
  description = "Bootstrap node instance size."
  default = "m3.medium"
}

variable "master_instance_type" {
  description = "Master node instance size."
  default = "m3.medium"
}

variable "agent_public_instance_type" {
  description = "Public agent node instance size."
  default = "m3.xlarge"
}

variable "agent_instance_type" {
  description = "Private agent node instance size."
  default = "m3.xlarge"
}

variable "key_name" {
  description = "Private SSH key name to use."
}

variable "key_path" {
  description = "Path to SSH private key for provisioning."
}
