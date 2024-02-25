variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-069fc124ab1aa6770",
    "subnet-064add82758968a69",
    "subnet-023e8fe69db8371dc",
  ]
}

variable "security_group_ids" {
  type = list(string)
  default = [
    "sg-0934f9ae495a2d1e3",
    "sg-0bd9ded3b1b8a40e1",
  ]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-ec2-db-subnet-group-1"
  subnet_ids = var.subnet_ids
  description = "Subnet group for RDS instance"
}

# Create an RDS DB instance
resource "aws_db_instance" "uat_db_instance" {
  allocated_storage = 150
  availability_zone = "eu-west-2b"
  backup_retention_period = 0
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  engine                  = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  name                   = "uat"
  parameter_group_name    = "default.mysql8.0"
  password               = "Victory123"
  port                   = 3306
  publicly_accessible    = false
  storage_type           = "gp2"
  username               = "root"
  vpc_security_group_ids = var.security_group_ids
  kms_key_arn            = "arn:aws:kms:eu-west-2:411390769206:alias/aws/rds"
  delete_protection      = true
  max_allocated_storage  = 1000

  # Enable encryption only if you have configured the KMS key correctly
  if aws_db_instance.uat_db_instance.kms_key_arn != "" {
    encryption = true
  }
}

# Output endpoint address
output "endpoint_address" {
  value = aws_db_instance.uat_db_instance.endpoint
}
