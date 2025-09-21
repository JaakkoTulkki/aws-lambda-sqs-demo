AWS CLI

brew install awscli

AWS credentials configured (use an IAM user with programmatic access, not root):

aws configure

Provide:

Access Key ID

Secret Access Key

Default region → eu-west-1

Output format → json

🚀 Usage

1. Package the Lambda code
   zip lambda.zip index.js

Re-run this every time you change index.js.

2. Initialize Terraform
   terraform init

3. Preview the plan
   terraform plan

4. Apply (create resources)
   terraform apply

Type yes when prompted.
On success, Terraform will output the Lambda Function URL.

5. Test the Lambda

Send a test payload:

curl -X POST https://<your-function-url>/ \
 -H "Content-Type: application/json" \
 -d '{"hello":"world"}'

Expected response:

{"status":"Message sent to SQS","payload":{"hello":"world"}}

📨 Testing SQS Directly (via AWS CLI)
List queues
aws sqs list-queues --region eu-west-1

Send a message
aws sqs send-message \
 --queue-url https://sqs.eu-west-1.amazonaws.com/<account-id>/hello-queue \
 --message-body '{"test":"Hello from CLI"}'

Receive messages
aws sqs receive-message \
 --queue-url https://sqs.eu-west-1.amazonaws.com/<account-id>/hello-queue

Delete a message

Copy the ReceiptHandle value from the previous step, then:

aws sqs delete-message \
 --queue-url https://sqs.eu-west-1.amazonaws.com/<account-id>/hello-queue \
 --receipt-handle "PASTE_RECEIPT_HANDLE_HERE"

🧹 Destroy (cleanup)

When you’re done testing, destroy everything to avoid costs:

terraform destroy

Type yes when prompted.
This will remove:

Lambda function + Function URL

IAM role + policy

SQS queue + DLQ

📂 Project Structure
aws-lambda-sqs-demo/
├── main.tf # Terraform infra
├── index.js # Lambda function code
├── lambda.zip # Zipped code for deployment (generated)
├── README.md # This file
└── .gitignore # Ignore terraform state + build artifacts

🪵 Debugging Lambda

To see logs in real time:

aws logs tail /aws/lambda/hello-lambda --follow
This will stream logs (console.log, errors) to your terminal.
