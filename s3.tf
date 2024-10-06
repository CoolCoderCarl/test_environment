resource "aws_s3_bucket" "bucket_patient_result_docs" {
  bucket = var.bucket_name

  tags = {
    Name        = "Patients Result Docs Bucket"
    Environment = "Dev"
  }
}
