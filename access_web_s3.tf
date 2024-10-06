resource "aws_iam_role" "web_ag_role" {
  #name = "ProjectWebAG"
  name = "web_ag_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "web_ag_s3_policy" {
  name        = "AccessAGUploadS3"
  description = "A policy to allow S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject"
        #"s3:*"
      ]
      Resource = "${aws_s3_bucket.bucket_patient_result_docs.arn}/*"
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
