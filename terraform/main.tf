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
  name          = "accept-form-post-data"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_route" "lambda-access-endpoint" {
  api_id    = aws_apigatewayv2_api.lambda-access-endpoint.id
  target    = "integrations/${aws_apigatewayv2_integration.lambda-access-endpoint.id}"
  route_key = "POST /api/formdata"
}

resource "aws_apigatewayv2_integration" "lambda-access-endpoint" {
  api_id                 = aws_apigatewayv2_api.lambda-access-endpoint.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda_save_to_s3.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_stage" "lambda-access-endpoint" {
  api_id      = aws_apigatewayv2_api.lambda-access-endpoint.id
  name        = "$default"
  auto_deploy = true

  default_route_settings {
    data_trace_enabled       = false
    detailed_metrics_enabled = false
    throttling_burst_limit   = 1
    throttling_rate_limit    = 1
  }

  route_settings {
    route_key              = aws_apigatewayv2_route.lambda-access-endpoint.route_key
    throttling_burst_limit = 1
    throttling_rate_limit  = 1
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda-access-endpoint.arn
    format = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        routeKey       = "$context.routeKey"
        status         = "$context.status"
      }
    )
  }

  lifecycle {
    ignore_changes = [
      deployment_id,
      default_route_settings
    ]
  }
}

resource "aws_cloudwatch_log_group" "lambda-access-endpoint" {
  name              = "lambda-access-endpoint"
  retention_in_days = 3
}
