resource "aws_lambda_function" "Lambda" {
  filename         = "${var.artifactPath}"
  function_name    = "${var.functionName}"
  role             = "${var.role_arn}"
  handler          = "${var.functionHandler}"
  source_code_hash = "${base64sha256(file("${var.artifactPath}"))}"
  runtime          = "dotnetcore2.0"
  timeout          = "20"
  publish          = "true"
  vpc_config = {
    subnet_ids = "${var.subnet_ids}"
    security_group_ids = "${var.security_group_ids}"
  }
  tags = {
    "Terraform" = "${var.terraformTagValue}"
  }
}