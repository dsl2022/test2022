# Multi Channels Messaging system

## Introduction

This is a quick implementation of AWS [AppSync](https://aws.amazon.com/appsync/?trk=41731cf6-f5eb-4611-81ef-f2914ec706b5&sc_channel=ps&sc_campaign=acquisition&sc_medium=GC-PMM|PS-GO|Brand|All|PA|Mobile%20Services|Amplify|US|EN|Text|PMO22-13306&s_kwcid=AL!4422!3!588971138398!e!!g!!aws%20appsync&ef_id=CjwKCAjwnZaVBhA6EiwAVVyv9NPre8Ac7MzG7KrhuEmvRIJvAbTBWb9lIZ2K_Ih-IbZpI5_c0R7DAxoCKtAQAvD_BwE:G:s&s_kwcid=AL!4422!3!588971138398!e!!g!!aws%20appsync) graphql server of a Multi Channels Message System API. The
resolvers were built with [dynamoDB stream](https://aws.amazon.com/blogs/big-data/monitor-your-application-for-processing-dynamodb-streams/). It also includes a lambda consumer function to consume the
stream and send SNS email notification when new channels or messages are created. The infrastructure was
spinned up through [Terraform](https://www.terraform.io/) and the lambda function were setup with Typescript. The whole application is
desployed and managed through [github action](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow).

## System Architecture

![img](/assets/architecture_diagram.png)

Deployment Architecture

![img](/assets/deployment.png)

## To Query through Postman

import [this collection]("multi-channel-message.postman_collection.json")

## Application Cost calculation

Query operation charges 5 million x $4.00 per million operations= $20.00
Data transfer charges 3 KB x 5 million = 15 million KB = 14.3 GB \* $0.09 = $1.29
Total AppSync charges $20.00 + $1.29 = \$21.29
[appsync pricing reference](https://aws.amazon.com/appsync/pricing/)

Since the monthly insert of messages and channels data are insignificant, so dynamodb cost is
not actively included here.

## Test

There is currently no integration testings implemented.

[challenge source](https://gist.github.com/skylinezum/fb789509faea5dda4442e4d7dfe1342f)
