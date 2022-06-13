# Multi Channels Messaging system

System Architecture

![img](/assets/architecture_diagram.png)

Deployment Architecture

![img](/assets/deployment.png)

Initial seeding some data to db

```
mutation addChannels {
  channel1: createChannel(id:1 name:"modern") { name }
  channel2: createChannel(id:2 name:"history") { name }
  channel3: createChannel(id:3 name:"technology") { name }
}
```

```
mutation addMessages {
  channel1: createMessage(id:1 ,channel:1,content:"a test message",title:"modern message",createdAt:"2022-01-23"){id,title,channel,content,createdAt}
  channel2: createMessage(id:2 ,channel:1,content:"a test message",title:"hisotry message",createdAt:"2022-02-21"){id,title,channel,content,createdAt}
  channel3: createMessage(id:3 ,channel:2,content:"a test message",title:"techology message",createdAt:"2022-03-13"){id,title,channel,content,createdAt}
  channel4: createMessage(id:4 ,channel:1,content:"a test message",title:"modern message",createdAt:"2022-03-03"){id,title,channel,content,createdAt}
  channel5: createMessage(id:5 ,channel:3,content:"a test message",title:"message title",createdAt:"2022-02-13"){id,title,channel,content,createdAt}
  channel6: createMessage(id:15,channel:3,content:"a message",title:"message title",createdAt:"2022-04-24"){id,title,channel,content,createdAt}
  channel7: createMessage(id:14,channel:1,content:"a message",title:"message title",createdAt:"2022-05-25"){id,title,channel,content,createdAt}
  channel8: createMessage(id:27,channel:2,content:"a message",title:"message title",createdAt:"2022-06-02"){id,title,channel,content,createdAt}
}
```

Example for querying all messages

```
{
  getAllMessages(count: 4, channel: 2) {
    messages {
      content
      createdAt
      id
      title
      channel
    }
    nextToken
  }
}
```

[source](https://gist.github.com/skylinezum/fb789509faea5dda4442e4d7dfe1342f)
