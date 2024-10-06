resource "aws_iam_role" "parser_lambda_role" {
  name = "parser_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "parser_s3_dynamodb_policy" {
  name        = "AccessParserGetS3PutDynamodb"
  description = "A policy to allow get from S3 and put in DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject"
        ],
        "Resource" : "arn:aws:s3:::bucket-patients-result-docs-1/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem"
        ],
        "Resource" : "arn:aws:dynamodb:us-east-1:867673051707:table/Prepared"
      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_s3_dynamodb_attachment" {
  policy_arn = aws_iam_policy.parser_s3_dynamodb_policy.arn
  role       = aws_iam_role.parser_lambda_role.name
}

resource "aws_iam_policy_attachment" "lambda_logs_policy" {
  name       = "lambda_logs_policy_attachment"
  roles      = [aws_iam_role.parser_lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_instance_profile" "lambda_s3_dynamodb_instance_profile" {
  name = "lambda_s3_dynamodb_instance_profile"
  role = aws_iam_role.parser_lambda_role.name
}

