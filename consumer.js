const https = require("https");

exports.handler = async (event) => {
  console.log("Received SQS event:", JSON.stringify(event, null, 2));

  const endpoint = process.env.OPENSEARCH_ENDPOINT;

  for (const record of event.Records) {
    const body = JSON.parse(record.body);

    // OpenSearch document structure
    const docId = new Date().getTime().toString(); // unique ID
    const data = JSON.stringify(body);

    const options = {
      hostname: endpoint.replace("https://", ""),
      path: `/my-index/_doc/${docId}`, // index = "my-index"
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(data),
      },
    };

    await new Promise((resolve, reject) => {
      const req = https.request(options, (res) => {
        let resp = "";
        res.on("data", (chunk) => (resp += chunk));
        res.on("end", () => {
          console.log("OpenSearch response:", resp);
          resolve();
        });
      });
      req.on("error", (e) => reject(e));
      req.write(data);
      req.end();
    });
  }

  return {};
};
