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

## Presenter - Sandhya

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

## 📚 Tech Stack

- Frontend: HTML and CSS for designing and building the user interface.
- Backend: Python for implementing business logic and server-side processing.
- Infrastructure: Terraform for designing, provisioning, and managing cloud resources as code.

## Presenter - Vincent

## Architecture Diagram:

## 📚 The Project File Structue and Directory

<pre>
ProjectGroup5/
├── .github/                        # GitHub configuration
│   └── workflows/                  # GitHub Actions workflows
│       ├── deploy_dev.yaml         # DEV deployment workflow
│       ├── deploy_prod.yaml        # PROD deployment workflow
│       ├── destroy_dev.yaml        # DEV destruction workflow
│       └── destroy_prod.yaml       # PROD destruction workflow
├── .gitignore                      # Git ignore rules
├── README.md                       # Project & Presentation documentation
├── lambda_function.py              # AWS Lambda function
├── requirements.txt                # Python dependencies
├── envs/                           # Terraform environments
│   ├── dev/                        # Development environment
│   │   ├── .terraform.lock.hcl     # Terraform lock file
│   │   ├── backend.tf              # Backend configuration
│   │   ├── data.tf                 # Data sources
│   │   ├── dev.tfvars              # Development variables
│   │   ├── main.tf                 # Main configuration
│   │   ├── output.tf               # Output definitions
│   │   ├── provider.tf             # Provider configuration
│   │   └── versions.tf             # Version constraints
│   └── prod/                       # Production environment
│       ├── .terraform.lock.hcl     # Terraform lock file
│       ├── backend.tf              # Backend configuration
│       ├── data.tf                 # Data sources
│       ├── main.tf                 # Main configuration
│       ├── output.tf               # Output definitions
│       ├── prd.tfvars              # Production variables
│       ├── provider.tf             # Provider configuration
│       └── versions.tf             # Version constraints
├── modules/                        # Terraform modules
│   ├── CloudWatch/                 # CloudWatch monitoring module
│   │   ├── main.tf                 # CloudWatch resources
│   │   ├── output.tf               # CloudWatch outputs
│   │   └── variables.tf            # CloudWatch variables
│   ├── Cloudfront-S3/              # CDN and storage module
│   │   ├── data.tf                 # Data sources
│   │   ├── main.tf                 # CloudFront/S3 resources
│   │   ├── output.tf               # CloudFront/S3 outputs
│   │   └── variables.tf            # CloudFront/S3 variables
│   └── Lambda-DB-API/              # Serverless API module
│       ├── main.tf                 # Lambda/API Gateway resources
│       ├── output.tf               # API/Lambda outputs
│       └── variables.tf            # API/Lambda variables
├── public/                         # Public assets
│   ├── Aws-SPA-XMLFile.svg         # AWS architecture diagram
│   ├── dev_qr.png                  # Development QR code
│   └── prod_qr.png                 # Production QR code
├── scripts/                        # Automation scripts
│   └── run-integration-tests.sh    # Integration testing script
└── static-website/                 # Website files
    ├── index.html                  # Main website file
    └── images/                     # Website images
        ├── 1.jpeg                  # Image asset
        ├── 2.jpeg                  # Image asset
        ├── 3.jpeg                  # Image asset
        ├── 4.jpeg                  # Image asset
        └── bgImage.jpg             # Background image
</pre>

1. AWS Services and Website Overview

![Alt text](public/Aws-SPA-XMLFile.svg)

2. CICD Pipeline Diagram

![Alt text](public/Project-CICD.svg)

## Presenter - Sankari

### 👨‍💻 Project Demonstration

Please scan the QR Code:

- Production QR:

![Alt text](public/prod_qr.png)

- Development QR:

![Alt text](public/dev_qr.png)

## Presenter - John

### 🎯 Importance

This initiative demonstrates the benefits of deployment automation and modern DevOps practices, highlighting how small-scale businesses can leverage cloud-native solutions to:

- Improve operational efficiency
- Reduce manual intervention
- Enhance scalability and security
- Deliver a superior customer experience

## Presentor: Cathrina

## 💰 Summary Estimate (per month)

| Service                            | Estimated Cost (USD) |
| ---------------------------------- | -------------------- |
| AWS Compute (EC2 / Lambda)         | $10 – $30            |
| Amazon S3 (Storage)                | $12                  |
| DynamoDB (NoSQL DB)                | $3.5                 |
| CloudFront (CDN)                   | $90                  |
| AWS WAF (Web Application Firewall) | $16                  |
| CloudWatch (Monitoring)            | $4                   |
| Route 53 (DNS & Hosted Zones)      | $1                   |
| ACM (SSL Certificates)             | $0                   |
| GitHub Actions (CI/CD – Free Tier) | $0                   |
| Snyk (Security – Free Tier)        | $0                   |
| Integration Testing                | $0                   |

---

**👉 Total Estimated Cost:** ~ **$136.5 – $156.5 per month**

**👉 Forecast Table**
| Period | Estimated Total Monthly Cost (USD)|
|-------------|-----------------------------------|
| Now | $136.5 – $156.5 |
| 3 Months | $165 – $200 |
| 6 Months | $200 – $245 |
| 12 Months | $265 – $320 |

---

## 📈 Scenario Highlights

### 🚀 Traffic Surge Scenario (+25% Bandwidth & Compute)

If you expect a product launch or viral growth:

- **CloudFront** may rise to $120+
- **EC2/Lambda** to $40–$50
- **Overall monthly cost:** $300–$400

### 🧊 Low-Usage / Static Scenario

If usage remains flat:

- **Monthly cost remains stable:** $136–$160

## Final Test
