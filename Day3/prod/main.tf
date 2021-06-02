provider "aws" {
  region = "us-west-2"
}

module "Ec2_mod" {
  source             = "../modules/Ec2"
  iam_instance_profile_name =  module.Role_mod.iam_instance_profile_name
  my_subnet_id              =  module.VPC_mod.my_subnet_id
  security_group_id         =  module.VPC_mod.security_group_id
}

module "Role_mod" {
  source          = "../modules/Role"
}

module "S3_mod" {
  source          = "../modules/S3"
}

module "VPC_mod" {
  source          = "../modules/VPC"
}
