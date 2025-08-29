# CapstoneProject-DevOps-CICDpipeline Group 5

## Team Member:

1. Cathrina
2. JohnBosco
3. Sandhya Karanam
4. Sivasankari
5. Vincent 

</ul>
<p>Students of PaCE@NTU enrolled in the SCTP Cloud Infrastructure Engineering course.</p>

<hr>

<h3>Project Overview</h3>
<ul>
    <li><strong>Project Name:</strong> CI/CD Pipeline for Web App Deployment on AWS ECS</li>
    <li><strong>Repository:</strong> GitHub Repository - [https://github.com/sandhyakaranam88/xxxx]</li>
</ul>

<hr>

## 1. Architecture Design

<h4>Application Structure</h4>
<pre>
/cp-cohort10-group5-capstone-grp5
|-- .github/workflows
    |-- deploy_dev.yaml
    |-- deploy_prod.yaml
    |-- destroy_dev.yaml
    |-- destroy_prod.yaml
|-- .terraform
    |-- providers/registry.terraform.io/hashicorp
    |-- terraform.tfstate
|-- envs
    |-- dev
        |-- terraform
        |-- terraform.lock.hcl
        |-- backend.tf
        |-- data.tf
        |-- main.tf
        |-- output.tf
        |-- provider.tf
        |-- versions.tf
    |-- prod
        |-- terraform
        |-- terraform.lock.hcl
        |-- backend.tf
        |-- data.tf
        |-- main.tf
        |-- output.tf
        |-- provider.tf
        |-- versions.tf
|-- modules
        |-- Cloudfront-S3
        |-- Lambda-DB-API
|-- static-website
        |-- images
        |-- index.html
|-- .gitignore
|-- .teraform.lock.hcl
|-- lambda_function.py
|-- process_order.zip
|-- README.md
</pre>

//////////////////////A