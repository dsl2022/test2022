# terraform {
#   backend "s3" {
#     encrypt = false
#     bucket  = "dsl-backend"
#     key     = "dsl.tfstate"
#     region  = "us-east-1"
#     profile = "default"
#   }
# }