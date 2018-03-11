resource "aws_api_gateway_rest_api" "ApiGateway" {
  name        = "${var.gatewayName}"
}

resource "aws_api_gateway_method" "ApiRootMethod" {
  rest_api_id         = "${aws_api_gateway_rest_api.ApiGateway.id}"
  http_method         = "ANY"
  authorization       = "NONE"
  request_parameters  = {"method.request.path.proxy" = true}
}

resource "aws_api_gateway_integration" "ApiRootIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ApiGateway.id}"
  resource_id             = "${aws_api_gateway_resource.root.id}"
  http_method             = "${aws_api_gateway_method.ApiRootMethod.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambdaArn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "ApiIntegrationRootResponse" {
    rest_api_id = "${aws_api_gateway_rest_api.ApiGateway.id}"
    resource_id = "${aws_api_gateway_resource.root.id}"
    http_method = "${aws_api_gateway_integration.ApiRootIntegration.http_method}"
    status_code = "200"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.ApiGateway.id}"
  parent_id   = "${aws_api_gateway_rest_api.ApiGateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "ApiProxyMethod" {
  rest_api_id         = "${aws_api_gateway_rest_api.ApiGateway.id}"
  resource_id         = "${aws_api_gateway_resource.proxy.id}"
  http_method         = "ANY"
  authorization       = "NONE"
  request_parameters  = {"method.request.path.proxy" = true}
}

resource "aws_api_gateway_integration" "ApiProxyIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.ApiGateway.id}"
  resource_id             = "${aws_api_gateway_resource.proxy.id}"
  http_method             = "${aws_api_gateway_method.ApiProxyMethod.http_method}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambdaArn}/invocations"
  content_handling        = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "ApiIntegrationProxyResponse" {
    rest_api_id = "${aws_api_gateway_rest_api.ApiGateway.id}"
    resource_id = "${aws_api_gateway_resource.proxy.id}"
    http_method = "${aws_api_gateway_integration.ApiProxyIntegration.http_method}"
    status_code = "200"
}

resource "aws_api_gateway_deployment" "ApiDeployment" {
  depends_on = ["aws_api_gateway_method.ApiProxyMethod","aws_api_gateway_method.ApiRootMethod", "aws_api_gateway_integration.ApiProxyIntegration", "aws_api_gateway_integration.ApiRootIntegration" ]
  rest_api_id = "${aws_api_gateway_rest_api.ApiGateway.id}"
  stage_name = "${var.stageName}"
  description = "Api gateway for  ${var.gatewayName}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambdaArn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.ApiGateway.id}/*"
}

resource "aws_api_gateway_base_path_mapping" "ApiDomainMapping" {
  api_id      = "${aws_api_gateway_rest_api.ApiGateway.id}"
  stage_name  = "${aws_api_gateway_deployment.ApiDeployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.ApiDomain.domain_name}"
}

resource "aws_api_gateway_domain_name" "ApiDomain" {
  domain_name = "${var.fqdn}"
  certificate_arn = "${var.certificateArn}"
}

resource "aws_route53_record" "ApiCName" {
  zone_id = "${var.route53ZoneId}"

  name = "${aws_api_gateway_domain_name.ApiDomain.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.ApiDomain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.ApiDomain.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}