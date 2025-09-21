const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");

const sqs = new SQSClient({ region: "eu-west-1" });
const QUEUE_URL = process.env.QUEUE_URL;

exports.handler = async (event) => {
  console.log("Incoming event:", event);

  try {
    const body = event.body ? JSON.parse(event.body) : { message: "no body" };

    const cmd = new SendMessageCommand({
      QueueUrl: QUEUE_URL,
      MessageBody: JSON.stringify(body),
    });

    await sqs.send(cmd);

    return {
      statusCode: 200,
      body: JSON.stringify({ status: "Message sent to SQS", payload: body }),
    };
  } catch (err) {
    console.error("Error sending to SQS:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Failed to send message",
        details: err.message,
      }),
    };
  }
};
