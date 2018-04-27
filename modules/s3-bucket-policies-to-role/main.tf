# ---------------------------------------------------------------------------------------------------------------------
# ATTACH AN IAM POLICY THAT ALLOWS THE FORTIFY SERVER TO REACH OUT TO S3 TO GRAB A OBJECT FROM A
# SPECIFIED BUCKET
# ---------------------------------------------------------------------------------------------------------------------


resource "aws_iam_role_policy" "read_object_from_bucket" {
  name   = "read_object_from_bucket"
  role   = "${var.iam_role_id}"
  policy = "${data.aws_iam_policy_document.read_object.json}"
}

data "aws_iam_policy_document" "read_object" {
  statement {
     actions = ["s3:*"] 
     resources = ["arn:aws-us-gov:s3:::${var.s3_bucket_name}/*"]
  }

  statement {
     actions = ["s3:*"]
     resources = ["arn:aws-us-gov:s3:::${var.s3_bucket_name}"]
  }
}

