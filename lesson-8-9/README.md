# Lesson 8–9 — CI/CD Pipeline with Jenkins, ECR, EKS and Argo CD (GitOps)

This project demonstrates a complete **CI/CD pipeline using Jenkins, AWS ECR, Amazon EKS and Argo CD with a GitOps workflow**.

The pipeline automatically:

1. Builds a Docker image of a Django application
2. Pushes the image to AWS ECR
3. Updates the GitOps repository with a new image tag
4. Argo CD automatically deploys the new version to Kubernetes

---

# Architecture

GitHub (Application Repo)
|
v
Jenkins
|
v
Build Docker Image
|
v
AWS ECR
|
v
Update GitOps Repo
|
v
Argo CD
|
v
Amazon EKS
|
v
Running Django App

---

# Infrastructure

The infrastructure was provisioned using **Terraform**.

## Terraform Apply Output

![lesson-8-9/img/1.png](img/1.png)

Infrastructure created:

- Amazon EKS Cluster
- AWS ECR Repository
- Jenkins Namespace
- Argo CD Namespace

Example Terraform outputs:

ecr_repository_name = "lesson-8-9-django"
ecr_repository_url = "827025938738.dkr.ecr.us-west-2.amazonaws.com/lesson-8-9-django"
eks_cluster_name = "lesson-8-9-eks-cluster"

![alt text](img/2.png)

# Kubernetes Cluster

After provisioning the infrastructure, the Kubernetes cluster is accessible.

## Namespaces

kubectl get ns

![lesson-8-9/img/3.png](img/3.png)

# Jenkins Deployment

Jenkins runs inside Kubernetes.

## Jenkins Pod

kubectl get pods -n jenkins

![lesson-8-9/img/4.png](img/4.png)

## Jenkins Service

kubectl get svc -n jenkins

The Jenkins UI is accessible via LoadBalancer.

![alt text](img/16.png)

## Jenkins Dashboard

![alt text](img/5.png)

# Jenkins Credentials

GitHub credentials were added to allow Jenkins to push updates to the GitOps repository.

![alt text](img/6.png)

Credential ID used in the pipeline:

github-https-creds

![alt text](img/7.png)

# Jenkins Pipeline

The pipeline performs:

1. Checkout application repository
2. Build Docker image
3. Push image to AWS ECR
4. Update GitOps repository with a new image tag

Pipeline execution example:

![lesson-8-9/img/8.png](img/8.png)

The pipeline finished successfully:

Finished: SUCCESS

![lesson-8-9/img/9.png](img/9.png)

# GitOps Repository

The GitOps repository stores Kubernetes manifests and Helm charts.

Repository:

https://github.com/Kate2603/django-gitops

## Helm Chart

charts/django-app

Image configuration:

image:
repository: 827025938738.dkr.ecr.us-west-2.amazonaws.com/lesson-8-9-django
tag: "e3046e2"

![lesson-8-9/img/10.png](img/10.png)

# Automatic GitOps Update

When Jenkins builds a new image, it updates the Helm values file automatically.

Example commit created by Jenkins:

Update image to e3046e2

![lesson-8-9/img/17.png](img/17.png)

# Argo CD Deployment

Argo CD monitors the GitOps repository and automatically deploys updates.

## Applications

kubectl get applications -n argocd

Output:

django-app Synced Healthy

![alt text](img/11.png)

# Argo CD Application Details

kubectl describe application django-app -n argocd

Important configuration:

Repo URL: https://github.com/Kate2603/django-gitops.git

Path: charts/django-app
Target Revision: main
Sync Policy: Automated
Self Heal: true
Prune: true

![lesson-8-9/img/11.png](img/11.png)

![alt text](img/12.png)

![alt text](img/13.png)

![alt text](img/14.png)

![alt text](img/15.png)

# Deployment Result

The deployed container image:

827025938738.dkr.ecr.us-west-2.amazonaws.com/lesson-8-9-django:e3046e2

Argo CD status:

Synced
Healthy

This confirms that the **GitOps workflow successfully deployed the application to Kubernetes.**

---

# CI/CD Flow Summary

1️⃣ Code pushed to GitHub  
2️⃣ Jenkins pipeline starts  
3️⃣ Docker image built using Kaniko  
4️⃣ Image pushed to AWS ECR  
5️⃣ Jenkins updates GitOps repository  
6️⃣ Argo CD detects changes  
7️⃣ Argo CD deploys application to EKS

---

# Technologies Used

- AWS EKS
- AWS ECR
- Terraform
- Kubernetes
- Jenkins
- Kaniko
- Argo CD
- Helm
- GitOps
- Docker
- Django
