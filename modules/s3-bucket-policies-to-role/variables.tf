# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "s3_bucket_name" {
  description = "The s3 bucket for the iam role policy to read from"
}

variable "iam_role_id" {
  description = "The ID of the IAM role to which these IAM policies should be attached"
}
