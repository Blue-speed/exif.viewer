variable "artifactPath" {
    type = "string"
    description = "The full path and filename of the .zip file containing the application"
}
variable "role_arn" {
    type = "string"
    description = "The role arn to create the lambda function as"
}
variable "terraformTagValue" {
    type = "string"
    description = "The tag value to add to the lambda function"
}