# CapstoneProject-DevOps-CICDpipeline Group 5

## Team Member:

1. Cathrina
2. John
3. Sandhya
4. Sivasankari
5. Vincent

<pre>
The platform was designed to facilitate the ordering of unique, fresh flower bouquets.

Every flower in this bouquet is a reminder that beauty blooms even in the smallest moments!
</pre>

## 🌸 Serverless Cloud-Native E-Commerce Platform

This capstone project implements a serverless, cloud-native e-commerce platform for selling flowers for various occasions. The solution emphasizes high availability, operational efficiency, security, and a seamless customer experience.
The project demonstrates how modern DevOps practices and cloud services can be integrated into a real-world e-commerce solution, providing a scalable and secure platform that small businesses could adopt and extend.

## 🚀 Key Features

Simaple, user-friendly website to browse collections, place orders, and track transactions.
Cloud-native architecture ensuring scalability, performance, and cost-efficiency.
Robust security controls including WAF, IAM policies, and automated vulnerability scanning.
Deployment automation through Infrastructure as Code (IaC) and CI/CD pipelines.

## 🛠️ Cloud Services & Technologies

### Frontend

- Website hosted on Amazon S3
- Content delivered globally via Amazon CloudFront

### Backend

- AWS Lambda for serverless compute
- Amazon API Gateway to handle requests
- Amazon DynamoDB for scalable NoSQL data storage

### Security

- AWS WAF to mitigate common web threats
- HTTPS/SSL encryption via AWS Certificate Manager (ACM)
- IAM roles and policies enforcing least-privilege access

### Snyk for automated vulnerability scanning

- DNS & Routing
- Amazon Route 53 for domain management and routing

### Monitoring

- Amazon CloudWatch for logs, performance metrics, and alerts

### Testing

- Automated integration testing to ensure correctness and reliability
- Source Control & CI/CD

### GitHub for source control

- GitHub Actions for CI/CD pipelines (build, test, deploy automation)

### Infrastructure as Code (IaC)

- Terraform for consistent, automated provisioning and management of AWS resources

## 🔒 Governance & Security Controls

1. Change Management / Control – All code changes undergo review and approval via GitHub before merging or deployment.
2. IAM Policies – Enforce strict least-privilege access for AWS resources (S3, Lambda, etc.).
3. Data Protection – Managed SSL/TLS certificates via ACM to secure data in transit.

📚 Tech Stack

- Frontend: HTML, CSS
- Backend: Python
- Infrastructure: Terraform

🎯 Importance
This initiative demonstrates the benefits of deployment automation and modern DevOps practices, highlighting how small-scale businesses can leverage cloud-native solutions to:

- Improve operational efficiency
- Reduce manual intervention
- Enhance scalability and security
- Deliver a superior customer experience

## 💰 Summary Estimate (per month)

| Service                                  | Estimated Cost (USD)   |
| ---------------------------------------- | ---------------------- |
| AWS Compute (EC2 / Lambda)               | $10 – $30              |
| Amazon S3 (Storage)                      | $12                    |
| DynamoDB (NoSQL DB)                      | $3.5                   |
| CloudFront (CDN)                         | $90                    |
| AWS WAF (Web Application Firewall)       | $16                    |
| CloudWatch (Monitoring)                  | $4                     |
| Route 53 (DNS & Hosted Zones)            | $1                     |
| ACM (SSL Certificates)                   | $0                     |
| GitHub Actions (CI/CD – Free Tier)       | $0                     |
| Snyk (Security – Free Tier)              | $0                     |
| Integration Testing                      | $0                     |
| ---------------------------------------- | ---------------------- |

**👉 Total Estimated Cost:** ~ **$136.5 – $156.5 per month**

## 📚 The Project File Structue and Directory

<pre>
/cp-cohort10-group5-capstone-grp5
├── .github/
│   └── workflows/
│       ├── deploy_dev.yaml
│       ├── deploy_prod.yaml
│       ├── destroy_dev.yaml
│       └── destroy_prod.yaml
├── .git/ (hidden directory)
├── envs/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── data.tf
│   │   ├── dev.tfvars
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   └── versions.tf
│   └── prod/
│       ├── backend.tf
│       ├── data.tf
│       ├── main.tf
│       ├── output.tf
│       ├── prd.tfvars
│       ├── provider.tf
│       └── versions.tf
├── modules/
│   ├── Cloudfront-S3/
│   │   ├── data.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── CloudWatch/
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── Lambda-DB-API/
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── scripts/
│   └── run-integration-tests.sh
├── static-website/
│   ├── images/
│   │   ├── 1.jpeg
│   │   ├── 2.jpeg
│   │   ├── 3.jpeg
│   │   ├── 4.jpeg
│   │   └── bgImage.jpg
│   └── index.html
├── lambda_function.py
├── README.md
└── requirements.txt
</pre>
