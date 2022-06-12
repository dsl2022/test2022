// eslint-disable-next-line @typescript-eslint/ban-ts-ignore
// @ts-ignore
const getData = (data): any =>
    Object.keys(data).reduce((acc: any, params: any): any => {
        const { S, N, B } = data[params];
        if (S) acc[params] = S;
        if (N) acc[params] = N;
        if (B) acc[params] = B;
        return { ...acc };
    }, {});

export async function handler({ Records }: { Records: any[] }) {
    try {
        Records.filter(({ eventName }) => eventName === 'INSERT').forEach(async (record) => {
            const data = getData(record.dynamodb.NewImage);
            console.log(data);
        });
    } catch (e) {}
    // switch (event.resolve) {
    //     case 'hello':
    //         callback(null, handlerHello());
    //         break;
    //     default:
    //         callback('Error: no resolver found', null);
    // }
}
