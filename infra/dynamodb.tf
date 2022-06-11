resource "aws_dynamodb_table" "message_channel" {
  name             = "message-channel"
  hash_key         = "type"
  range_key        = "id"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
    global_secondary_index {
    name               = "sort-by-nummber-id"
    hash_key           = "type"
    range_key          = "id"    
    projection_type    = "ALL"    
  }
  attribute {
    name = "type"
    type = "S"
  }
  attribute {
    name = "id"
    type = "N"
  }
}