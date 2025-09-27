🔹 IAM Role Cheat Sheet

| Terraform property | Example value                                               | When to use                                                                                  |
| ------------------ | ----------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **`name`**         | `sqs-consumer-exec`                                         | When an AWS API expects the **role name only** (e.g. `aws_iam_role_policy_attachment.role`). |
| **`id`**           | `sqs-consumer-exec` (same as `name` for roles in Terraform) | When Terraform resources require the “canonical id” (e.g. `aws_iam_role_policy.role`).       |
| **`arn`**          | `arn:aws:iam::123456789012:role/sqs-consumer-exec`          | When AWS APIs expect a **fully qualified identifier** (e.g. `aws_lambda_function.role`).     |

🔹 IAM Policy Cheat Sheet

| Terraform property | Example value                                                          | When to use                                                        |
| ------------------ | ---------------------------------------------------------------------- | ------------------------------------------------------------------ |
| **`name`**         | `consumer-sqs`                                                         | When attaching/detaching policies by name.                         |
| **`id`**           | `arn:aws:iam::123456789012:policy/consumer-sqs` (for managed policies) | Sometimes required by Terraform as canonical identifier.           |
| **`arn`**          | `arn:aws:iam::123456789012:policy/consumer-sqs`                        | When attaching a **managed policy** to a role (e.g. `policy_arn`). |

🔹 IAM User Cheat Sheet
| Terraform property | Example value | When to use |
| ------------------ | ----------------------------------------------- | ---------------------------------------------------------------------------------- |
| **`name`** | `ci-cd-bot` | For human-readable references, like inline policy attachments. |
| **`id`** | `AIDACKCEVSQ6C2EXAMPLE` (AWS-generated user ID) | Rarely needed, but Terraform uses it internally as canonical. |
| **`arn`** | `arn:aws:iam::123456789012:user/ci-cd-bot` | When granting permissions across accounts or when AWS explicitly requires the ARN. |
