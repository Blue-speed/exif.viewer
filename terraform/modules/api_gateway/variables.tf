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