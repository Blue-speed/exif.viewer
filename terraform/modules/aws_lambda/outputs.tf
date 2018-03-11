output "arn" {
  value = "${aws_lambda_function.Lambda.arn}"
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function"
}
output "invoke_arn" {
  value = "${aws_lambda_function.Lambda.invoke_arn}"
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
}