provider "aws" {
  region = "${var.region}"
}

terraform  {
  backend "s3" {
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
  functionName = "Drewgle"
  subnet_ids = ["subnet-dec1c4f4", "subnet-28e9ec70", "subnet-cb5fedc7", "subnet-1134ba74"]
  security_group_ids = ["sg-d152bdab"]
  functionHandler = "exif.viewer::exif.viewer.LambdaEntryPoint::FunctionHandlerAsync"
}

module "apiProxy" {
  source = "./modules/api_gateway"
  lambdaArn = "${module.lambdaFunction.arn}"
  region = "${var.region}"
  accountId = "${var.accountId}"
  stageName = "${var.stageName}"
  route53ZoneId = "ZW040HD0W8EVI"
  fqdn = "drewgle.me"
  certificateArn = "arn:aws:acm:us-east-1:115338466642:certificate/428367e3-1583-415f-8827-dd7bbcf6fc35"
  gatewayName = "Drewgle"
}