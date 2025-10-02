# Terraform file with security issues

# CKV_AWS_20: S3 bucket without encryption
resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket"
  acl    = "public-read"  # CKV_AWS_19: Public S3 bucket
}

# CKV_AWS_8: Security group with unrestricted ingress
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web servers"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all traffic
  }
}

# CKV_AWS_46: EC2 instance without encryption
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  # No encryption enabled
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
    encrypted   = false  # CKV_AWS_3: Unencrypted EBS volume
  }
}

# CKV_AWS_23: Security group with SSH open to the world
resource "aws_security_group" "ssh_sg" {
  name = "ssh-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CKV_AWS_24: RDS instance without encryption
resource "aws_db_instance" "database" {
  identifier        = "mydb"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = "admin"
  password          = "hardcodedpassword123"  # CKV_AWS_161: Hardcoded password
  skip_final_snapshot = true
  storage_encrypted = false  # No encryption
  publicly_accessible = true  # CKV_AWS_17: Publicly accessible database
}
