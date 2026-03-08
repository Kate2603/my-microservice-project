aws_region   = "us-west-2"
project_name = "lesson-db-module"
environment  = "dev"

vpc_id = "vpc-0f957bd1b2d6d0b9b"

private_subnet_ids = [
  "subnet-03f0361b5141dfb07",
  "subnet-0829ce936ec666428"
]

allowed_cidr_blocks = [
  "172.31.0.0/16"
]