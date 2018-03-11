resource "aws_lambda_function" "Lambda" {
  filename         = "${var.artifactPath}"
  function_name    = "Drewgle-exif-viewer"
  role             = "${var.role_arn}"
  handler          = "exif.viewer::exif.viewer.LambdaEntryPoint::FunctionHandlerAsync"
  source_code_hash = "${base64sha256(file("${var.artifactPath}"))}"
  runtime          = "dotnetcore2.0"
  timeout          = "20"
  publish          = "true"
  environment {
    variables = {
    }
  }
  vpc_config = {
    subnet_ids = ["subnet-3d5b0e10", "subnet-9a5820b7"]
    security_group_ids = ["sg-3d07d741"]
  }
  tags = {
    "Terraform" = "${var.terraformTagValue}"
  }
}