resource "aws_dynamodb_table" "prepared_dynamodb" {
  name           = "Prepared"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "EMail"
  range_key      = "PacientName"

  attribute {
    name = "EMail"
    type = "S"
  }

  attribute {
    name = "PacientName"
    type = "S"
  }

  #  attribute {
  #    name = "INR"
  #    type = "S"
  #  }


  #  global_secondary_index {
  #    name               = "PacientName-index"
  #    hash_key           = "PacientName"
  #    write_capacity     = 10
  #    read_capacity      = 10
  #    projection_type    = "KEYS_ONLY" # Corrected projection_type
  #    non_key_attributes = []
  #  }


  #  global_secondary_index {
  #    name               = "INR-index"
  #    hash_key           = "INR"
  #    write_capacity     = 10
  #    read_capacity      = 10
  #    projection_type    = "ALL"
  #    non_key_attributes = []
  #  }


  tags = {
    Name        = "pacients-db"
    Environment = "Dev"
  }
}


#resource "aws_lambda_event_source_mapping" "dynamodb_event" {
#  event_source_arn  = aws_dynamodb_table.prepared_dynamodb.stream_arn
#  function_name     = aws_lambda_function.cogito_lambda_function.arn
#  starting_position = "LATEST"
#}

