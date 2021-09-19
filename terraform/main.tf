resource "aws_lambda_function" "lambda_save_to_s3" {
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda.handler"
  runtime          = "python3.9"
  filename         = "lambda.zip"
  function_name    = "lambda_function"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      bucket_name = aws_s3_bucket.lambda_s3_bucket.id
      auth_token  = var.auth_token
    }
  }
}

resource "aws_apigatewayv2_api" "lambda-access-endpoint" {
    name                         = "accept-form-post-data"
    protocol_type                = "HTTP"
}


resource "aws_apigatewayv2_route" "lambda-access-endpoint" {
    api_id               = aws_apigatewayv2_api.lambda-access-endpoint.id
    target               = "integrations/${aws_apigatewayv2_integration.lambda-access-endpoint.id}"
    route_key            = "POST /api/formdata"
}

resource "aws_apigatewayv2_integration" "lambda-access-endpoint" {
    api_id                 = aws_apigatewayv2_api.lambda-access-endpoint.id
    integration_method     = "POST"
    integration_type       = "AWS_PROXY"
    integration_uri        = aws_lambda_function.lambda_save_to_s3.arn
    payload_format_version = "2.0"
}
