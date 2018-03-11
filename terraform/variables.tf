variable "artifactPath" {
  type = "string"
  description = "The full path and file name to the application .zip file "
}

variable "stageName" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-east-1"
}
variable "terraformTagValue" {
  type = "string"
  default = "Drewgle-exif-viewer"
}

variable "role" {
  type = "string"
  default = "arn:aws:iam::115338466642:role/AwsLambda"
}

variable "accountId" {
  type = "string"
  default = "115338466642"
}