# -----------------------------------------------------------------------------
# Lambda: function Hello World
# -----------------------------------------------------------------------------
data "archive_file" "function_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../dist"
  output_path = "${path.module}/../dist/function.zip"
}

resource "aws_lambda_function" "ddb_stream_consumer" {
  filename         = data.archive_file.function_archive.output_path
  function_name    = "${var.namespace}-ddb_stream_consumer-ts"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.function_archive.output_base64sha256
#   lambda_policy = aws_iam_policy_document.lambda_policy.json
  # Lambda Runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime     = "nodejs16.x"
  timeout     = "30"
  memory_size = 128
}


resource "aws_lambda_event_source_mapping" "ddb_lambda_event" {
  event_source_arn = aws_dynamodb_table.message_channel.stream_arn
  function_name = aws_lambda_function.ddb_stream_consumer.function_name
  starting_position = "TRIM_HORIZON"
}

# data "aws_iam_policy_document" "lambda_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#         "dynamodb:*",
#         "sns:*",
#         "kms:*"
#         ]
#     resources = ["*"]
     
#      }
#     }