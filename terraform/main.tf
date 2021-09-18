resource "aws_lambda_function" "lambda_save_to_s3" {
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda.handler"
  runtime       = "python3.9"
  filename      = "lambda.zip"
  function_name = "lambda_function"

  environment {
    variables = {
      bucket_name = aws_s3_bucket.lambda_s3_bucket.id
      auth_token  = var.auth_token
    }
  }
}
