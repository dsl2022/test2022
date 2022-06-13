// eslint-disable-next-line @typescript-eslint/ban-ts-ignore
// @ts-ignore
const aws = require('aws-sdk');
const sns = new aws.SNS({ apiVersion: '2010-03-31' });
const getData = (data: any): any =>
    Object.keys(data).reduce((acc: any, params: any): any => {
        const { S, N, B } = data[params];
        if (S) acc[params] = S;
        if (N) acc[params] = N;
        if (B) acc[params] = B;
        return { ...acc };
    }, {});

export async function handler({ Records }: { Records: any[] }) {
    try {
        const result = Records.filter(({ eventName }) => eventName === 'INSERT').map(async (record) =>
            getData(record.dynamodb.NewImage)
        );
        const response = await Promise.all(result);
        const params = {
            Message: `New Channels have been created ${JSON.stringify(response)}`,
            TopicArn: process.env.SNS_TOPIC_ARN,
        };
        const snsResponse = await sns.publish(params).promise();
        console.log(snsResponse);
    } catch (e) {
        console.log(e);
    }
    // switch (event.resolve) {
    //     case 'hello':
    //         callback(null, handlerHello());
    //         break;
    //     default:
    //         callback('Error: no resolver found', null);
    // }
}
