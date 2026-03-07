# Microservice Infrastructure Deployment (Lesson 7)

terraform fmt -recursive
terraform init -reconfigure
terraform validate
terraform apply -target=module.ecr -target=module.eks -auto-approve

![alt text](img/1.png)

terraform apply -auto-approve

![alt text](img/2.png)

kubectl get pods -n jenkins
kubectl get svc -n jenkins

![alt text](img/4.png)

kubectl get ns

![alt text](img/3.png)

Заходимо на jenkins

http://af3dae37370fe467da8daf79992b2007-1872810586.us-west-2.elb.amazonaws.com:8080/

![alt text](img/5.png)
