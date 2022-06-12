# Multi Channels Messaging system

System Architecture

![img](/assets/architecture_diagram.png)

Deployment Architecture

![img](/assets/deployment.png)

Initial seeding some data to db

```
mutation addChannels {
  channel1: createChannel(id:1 name:"John") { name }
  channel2: createChannel(id:2 name:"Murphy") { name }
  channel3: createChannel(id:3 name:"Daniel") { name }
  channel4: createChannel(id:4 name:"Jack") { name }
  channel5: createChannel(id:5 name:"Tom") { name }
  channel6: createChannel(id:15 name:"Matt") { name }
  channel7: createChannel(id:14 name:"Rose") { name }
  channel8: createChannel(id:27 name:"Zoe") { name }
}
```

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

https://gist.github.com/skylinezum/fb789509faea5dda4442e4d7dfe1342f
