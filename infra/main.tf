locals {
  tags = {
    Project = var.namespace
    Owner   = "fdex24@gmail.com"
  }
}

# -----------------------------------------------------------------------------
# AppSync: General
# -----------------------------------------------------------------------------
data "local_file" "schema" {
  filename = "${path.module}/schema.graphql"
}

resource "aws_appsync_graphql_api" "message_channel" {
  authentication_type = "API_KEY"
  name                = "message-channel"
  schema              = file("${path.module}/schema.graphql")
}

resource "aws_appsync_datasource" "add_channel" {
  api_id           = aws_appsync_graphql_api.message_channel.id
  name             = "tf_appsync_example"
  service_role_arn = aws_iam_role.ddb_resolver.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.message_channel.name
  }
}

resource "aws_appsync_datasource" "query_channel" {
  api_id           = aws_appsync_graphql_api.message_channel.id
  name             = "query_channel"
  service_role_arn = aws_iam_role.ddb_resolver.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.message_channel.name
  }
}

resource "aws_appsync_datasource" "add_message" {
  api_id           = aws_appsync_graphql_api.message_channel.id
  name             = "add_messages"
  service_role_arn = aws_iam_role.ddb_resolver.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.message_channel_messages.name
  }
}

resource "aws_appsync_datasource" "get_messages" {
  api_id           = aws_appsync_graphql_api.message_channel.id
  name             = "get_messages"
  service_role_arn = aws_iam_role.ddb_resolver.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.message_channel_messages.name
  }
}

# -----------------------------------------------------------------------------
# AppSync: IAM
# -----------------------------------------------------------------------------

resource "aws_iam_role" "ddb_resolver" {
  name = "ddb_resolver"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "appsync.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ddb_resolver_policy" {
  name = "ddb_resolver_policy"
  role = aws_iam_role.ddb_resolver.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

# data "template_file" "lambda_target_policy" {
#   template = file("${path.module}/policies/lambda-policy.json")
#   vars = {
#     POLICY_ARN = aws_lambda_function.lambdaHello.arn
#   }
# }

# resource "aws_iam_role" "lambda-role" {
#   name               = "${aws_lambda_function.lambdaHello.function_name}-Role"
#   assume_role_policy = file("${path.module}/policies/lambda-role.json")
# }

# resource "aws_iam_policy" "lambda_invoke_lambda" {
#   name = "${aws_iam_role.lambda-role.name}-Policy"

#   policy = data.template_file.lambda_target_policy.rendered
# }

# -----------------------------------------------------------------------------
# AppSync: DataSource
# -----------------------------------------------------------------------------
//module "lambda-datasource" {
//  source = "./modules/lambda-datasource"
//
//  name                     = "datasourcelambdahello"
//  api_id                   = aws_appsync_graphql_api._.id
//  lambda_function_arn      = aws_lambda_function.lambdaHello.arn
//  invoke_lambda_policy_arn = aws_iam_policy.lambda_invoke_lambda.arn
//  role_name_prefix         = var.namespace
//  description              = "Datasource that call the Hello lambda"
//}

# resource "aws_appsync_datasource" "lambda_datasource" {
#   api_id      = aws_appsync_graphql_api.message_channel.id
#   description = "Datasource that call the Hello lambda"

#   lambda_config {
#     function_arn = aws_lambda_function.lambdaHello.arn
#   }

#   name             = "datasourcelambdahello"
#   service_role_arn = aws_iam_role.lambda_datasource_role.arn
#   type             = "AWS_LAMBDA"
# }


# -----------------------------------------------------------------------------
# AppSync: Resolver
# -----------------------------------------------------------------------------
# resource "aws_appsync_resolver" "helloworld_lambda" {
#   api_id      = aws_appsync_graphql_api.message_channel.id
#   field       = "hello"
#   type        = "Query"
#   data_source = aws_appsync_datasource.lambda_datasource.name

#   request_template = <<EOF
# {
#     "version" : "2017-02-28",
#     "operation": "Invoke",
#     "payload": {
#     	"resolve": "hello"
#     }
# }
# EOF

#   response_template = <<EOF
#     $util.toJson($context.result)
# EOF
# }