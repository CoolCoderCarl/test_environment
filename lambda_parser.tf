#resource "aws_lambda_layer_version" "parser_lambda_layer" {
#  layer_name          = "parser_lambda_layer"
#  description         = "A layer for PDF processing with pdfplumber and cryptography"
#  compatible_runtimes = ["python3.12"]
#
#  filename = "lambda_layer.zip"
#
#  source_code_hash = filebase64sha256("lambda_layer.zip")
#}

resource "aws_lambda_function" "parser_lambda_function" {
  function_name = "parser_lambda_function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = aws_iam_role.parser_lambda_role.arn

  #layers = [aws_lambda_layer_version.parser_lambda_layer.arn]
  timeout = 30

  filename = "lambda_parser.zip"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.parser_lambda_function.function_name}"
  retention_in_days = 1
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.parser_lambda_function.function_name
  principal     = "logs.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.lambda_log_group.arn}:*"
}


resource "aws_s3_bucket_notification" "s3_notification" {
  bucket = aws_s3_bucket.bucket_patient_result_docs.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.parser_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}
