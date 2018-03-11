provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "master_state" {
  backend = "s3"
  config {
    bucket = "issuetrak-deployment-development"
    key    = "issuetrak-web-forms-service/terraform/isc_state/terraform.tfstate"
    region = "us-east-1"
  }
}

module "lambdaFunction" {
  source = "../modules/aws_lambda"
  artifactPath = "${var.artifactPath}"
  role_arn = "${var.role}"
  bucket = "${var.bucket}"
  terraformTagValue = "${var.terraformTagValue}"
}

module "apiProxy" {
  source = "../modules/api_gateway"
  lambdaArn = "${module.lambdaFunction.arn}"
  region = "${var.region}"
  accountId = "${var.accountId}"
  stageName = "${var.stageName}"
}