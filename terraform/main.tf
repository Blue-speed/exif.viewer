provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "master_state" {
  backend = "s3"
  config {
    bucket = "bluespeed-terraform"
    key    = "exif-viewer"
    region = "us-east-1"
  }
}

module "lambdaFunction" {
  source = "./modules/aws_lambda"
  artifactPath = "${var.artifactPath}"
  role_arn = "${var.role}"
  terraformTagValue = "${var.terraformTagValue}"
}

module "apiProxy" {
  source = "./modules/api_gateway"
  lambdaArn = "${module.lambdaFunction.arn}"
  region = "${var.region}"
  accountId = "${var.accountId}"
  stageName = "${var.stageName}"
}