resource "aws_lambda_function" "Lambda" {
  filename         = "${var.artifactPath}"
  function_name    = "Drewgle-exif-viewer"
  role             = "${var.role_arn}"
  handler          = "exif.viewer::exif.viewer.LambdaEntryPoint::FunctionHandlerAsync"
  source_code_hash = "${base64sha256(file("${var.artifactPath}"))}"
  runtime          = "dotnetcore2.0"
  timeout          = "20"
  publish          = "true"
  vpc_config = {
    subnet_ids = ["subnet-dec1c4f4", "subnet-28e9ec70", "subnet-cb5fedc7", "subnet-1134ba74"]
    security_group_ids = ["sg-d152bdab"]
  }
  tags = {
    "Terraform" = "${var.terraformTagValue}"
  }
}