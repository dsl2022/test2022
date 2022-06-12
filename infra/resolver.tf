resource "aws_appsync_resolver" "add_channel_resolver" {
  api_id      = aws_appsync_graphql_api.message_channel.id
  field       = "createChannel"
  type        = "Mutation"
  data_source = aws_appsync_datasource.add_channel.name

  request_template = <<EOF
{
    "version": "2018-05-29",
    "operation": "PutItem",
    "key": {
        "id":$util.dynamodb.toDynamoDBJson($ctx.args.id),
        "type": $util.dynamodb.toDynamoDBJson("channel")
    },
    "attributeValues": {        
        "name": $util.dynamodb.toDynamoDBJson($ctx.args.name)
        }
}
EOF

  response_template = <<EOF
    $util.toJson($context.result)
EOF

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]
    ttl = 60
  }
}

resource "aws_appsync_resolver" "get_channel_resolver" {
  api_id      = aws_appsync_graphql_api.message_channel.id
  field       = "getChannel"
  type        = "Query"
  data_source = aws_appsync_datasource.query_channel.name

  request_template = <<EOF
    {
        "version" : "2017-02-28",
        "operation" : "GetItem",
        "key": {
         "id":$util.dynamodb.toDynamoDBJson($ctx.args.id)
        }
    }
EOF

  response_template = <<EOF
    $util.toJson($context.result)
EOF

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]
    ttl = 60
  }
}

resource "aws_appsync_resolver" "get_all_channel_resolver" {
  api_id      = aws_appsync_graphql_api.message_channel.id
  field       = "getAllChannels"
  type        = "Query"
  data_source = aws_appsync_datasource.query_channel.name

  request_template = <<EOF
        {
        "version" : "2017-02-28",
        "operation" : "Query",
         "query":{
         	"expression":"#type = :type",
            "expressionNames":{
            	"#type":"type"
            },
            "expressionValues":{
            	":type": $util.dynamodb.toDynamoDBJson("channel")
            }
         },
         "index":"sort-by-nummber-id",
         "scanIndexForward":true        
        #if( $context.arguments.count )
            ,"limit": $util.toJson($context.arguments.count)
        #end
        #if( $context.arguments.nextToken )
            ,"nextToken": $util.toJson($context.arguments.nextToken)
        #end
    }
EOF

  response_template = <<EOF
      {
    "channels": $util.toJson($context.result.items)
    #if( $context.result.nextToken )
        ,"nextToken": $util.toJson($context.result.nextToken)
    #end
}
EOF

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]
    ttl = 60
  }
}

resource "aws_appsync_resolver" "add_channel_message_resolver" {
  api_id      = aws_appsync_graphql_api.message_channel.id
  field       = "createMessage"
  type        = "Mutation"
  data_source = aws_appsync_datasource.add_message.name

  request_template = <<EOF
{
    "version": "2018-05-29",
    "operation": "PutItem",
    "key": {
        "id":$util.dynamodb.toDynamoDBJson($ctx.args.id),
        "type": $util.dynamodb.toDynamoDBJson("message")
    },
    "attributeValues": {        
        "title": $util.dynamodb.toDynamoDBJson($ctx.args.title),
        "content": $util.dynamodb.toDynamoDBJson($ctx.args.content),
        "channel": $util.dynamodb.toDynamoDBJson($ctx.args.channel),
        "createdAt": $util.dynamodb.toDynamoDBJson($ctx.args.createdAt)
        }
}
EOF

  response_template = <<EOF
    $util.toJson($context.result)
EOF

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]
    ttl = 60
  }
}


resource "aws_appsync_resolver" "get_all_messages_resolver" {
  api_id      = aws_appsync_graphql_api.message_channel.id
  field       = "getAllMessages"
  type        = "Query"
  data_source = aws_appsync_datasource.get_messages.name

  request_template = <<EOF
        {
        "version" : "2017-02-28",
        "operation" : "Query",
         "query":{
         	"expression":"#type = :type",
            "expressionNames":{
            	"#type":"type"
            },
            "expressionValues":{
            	":type": $util.dynamodb.toDynamoDBJson("message")
            }
         },
         "index":"sort-by-nummber-id",
         "scanIndexForward":true
         "filter": {
            "expression": "contains (channel, :channel)",
            "expressionValues": {
            ":channel": $util.dynamodb.toDynamoDBJson($context.arguments.channel)
          }
        }    
        #if( $context.arguments.count )
            ,"limit": $util.toJson($context.arguments.count)
        #end
        #if( $context.arguments.nextToken )
            ,"nextToken": $util.toJson($context.arguments.nextToken)
        #end
    }
EOF

  response_template = <<EOF
      {
    "channels": $util.toJson($context.result.items)
    #if( $context.result.nextToken )
        ,"nextToken": $util.toJson($context.result.nextToken)
    #end
}
EOF

  caching_config {
    caching_keys = [
      "$context.identity.sub",
      "$context.arguments.id",
    ]
    ttl = 60
  }
}
