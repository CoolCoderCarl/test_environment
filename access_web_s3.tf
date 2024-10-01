resource "aws_iam_role" "web_ag_role" {
  name = "web_ag_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        #Service = "ec2.amazonaws.com"
        Service = "autoscaling.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_policy" "web_ag_s3_policy" {
  name        = "web_ag_s3_policy"
  description = "A policy to allow S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject"
      ]
      Resource = "${aws_s3_bucket.res_bucket.arn}/*" # Allow access to all objects in the bucket
    }]
  })
}

resource "aws_iam_role_policy_attachment" "web_ag_s3_attachment" {
  policy_arn = aws_iam_policy.web_ag_s3_policy.arn
  role       = aws_iam_role.web_ag_role.name
}

resource "aws_iam_instance_profile" "web_ag_instance_profile" {
  name = "web_ag_instance_profile"
  role = aws_iam_role.web_ag_role.name
}
