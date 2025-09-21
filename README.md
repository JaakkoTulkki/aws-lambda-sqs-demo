# AWS Lambda + Function URL Demo (Terraform)

This project creates a simple public-facing Lambda function with a Function URL using Terraform.  
The Lambda just returns `"Hello from Lambda Function URL!"` in JSON.

---

## 📦 Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed (`brew install hashicorp/tap/terraform`)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed (`brew install awscli`)
- AWS credentials configured (`aws configure`) with an IAM user that has permissions for Lambda + IAM

---

## 🚀 Usage

### 1. Zip the Lambda code

From the project root:

```bash
zip lambda.zip index.js
```
