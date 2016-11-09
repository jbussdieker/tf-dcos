# Terraform DC/OS

Creates a DC/OS cluster using Terraform.

## Usage

````
cp terraform.tfvars.sample terraform.tfvars
vi terraform.tfvars
terraform apply
````

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | Name to assign to the DC/OS cluster. | `"dcos-test"` | no |
| trusted_cidr | Administrative CIDR block to whitelist. | - | yes |
| master_count | Number of master nodes to create. | `"1"` | no |
| agent_public_count | Number of public agent nodes to create. | `"1"` | no |
| agent_count | Number of agent nodes to create. | `"1"` | no |
| region | AWS region to launch into. | `"us-east-1"` | no |
| ami | CoreOS AMI to use. | `"ami-4d795c5a"` | no |
| bootstrap_instance_type | Bootstrap node instance size. | `"m3.medium"` | no |
| master_instance_type | Master node instance size. | `"m3.medium"` | no |
| agent_public_instance_type | Public agent node instance size. | `"m3.xlarge"` | no |
| agent_instance_type | Private agent node instance size. | `"m3.xlarge"` | no |
| key_name | Private SSH key name to use. | - | yes |
| key_path | Path to SSH private key for provisioning. | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| exhibitor_url | URL to access the Exhibitor UI |
| dcos_url | URL to access the DC/OS UI |
