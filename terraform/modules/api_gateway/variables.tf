variable "lambdaArn" {
    type = "string"
    description = "The lambda arn to connect the api gateway to"
}
variable "region" {
    type = "string"
    description = "The region to stand up all the resources in"
}
variable "accountId" {
    type = "string"
    description = "The aws account id"
}
variable "stageName" {
    type = "string"
    description = "The stage to deploy to"
}
variable "route53ZoneId" {
    type = "string"
    description = "Zone Id for the domain to use"
}
variable "fqdn" {
    type = "string"
    description = "Fully qualified Domain Name"
}
variable "certificateArn" {
    type = "string"
    description = "Arn of the Https Certificate of the FQDN"
}
variable "gatewayName" {
    type = "string"
    description = "The api gateway name"
}