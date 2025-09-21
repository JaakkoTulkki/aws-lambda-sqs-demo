exports.handler = async (event) => {
  console.log("Received SQS event:", JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    const body = record.body;
    console.log("Processing message:", body);
  }

  return {};
};
