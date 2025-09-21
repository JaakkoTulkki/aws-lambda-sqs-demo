terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "lambda_exec" {
  name = "hello-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hello" {
  function_name = "hello-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.hello_queue.id
    }
  }
}


resource "aws_lambda_function_url" "hello_url" {
  function_name      = aws_lambda_function.hello.function_name
  authorization_type = "NONE"
}

# Dead Letter Queue
resource "aws_sqs_queue" "hello_dlq" {
  name                      = "hello-dlq"
  message_retention_seconds = 1209600 # 14 days (max)
}

# Main SQS Queue
resource "aws_sqs_queue" "hello_queue" {
  name                       = "hello-queue"
  visibility_timeout_seconds = 30
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hello_dlq.arn
    maxReceiveCount     = 3
  })
}

resource "aws_iam_role_policy" "lambda_sqs_send" {
  name = "lambda-sqs-send"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "sqs:SendMessage"
      Resource = aws_sqs_queue.hello_queue.arn
    }]
  })
}





output "function_url" {
  value = aws_lambda_function_url.hello_url.function_url
}

output "sqs_queue_url" {
  value = aws_sqs_queue.hello_queue.id
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.hello_dlq.id
}
