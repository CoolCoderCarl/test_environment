resource "aws_dynamodb_table" "prepared-dynamodb" {
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

