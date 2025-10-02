# Terraform configuration with intentional security issues for Checkov detection

# Issue 1: S3 bucket without encryption
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket"

  # Missing encryption configuration
  # Missing versioning
  # Missing logging
}

# Issue 2: S3 bucket with public access
resource "aws_s3_bucket_public_access_block" "bad_public_access" {
  bucket = aws_s3_bucket.insecure_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Issue 3: Security group with unrestricted ingress
resource "aws_security_group" "wide_open" {
  name        = "wide-open-sg"
  description = "Security group with unrestricted access"

  ingress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Issue 4: RDS instance without encryption
resource "aws_db_instance" "unencrypted_db" {
  identifier           = "my-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = "password123"  # Hardcoded password
  
  # Missing encryption
  storage_encrypted    = false
  
  # Missing backup retention
  backup_retention_period = 0
  
  # Public accessibility enabled
  publicly_accessible  = true
  
  skip_final_snapshot  = true
}

# Issue 5: EC2 instance with unrestricted IAM role
resource "aws_iam_role_policy" "overly_permissive" {
  name = "overly-permissive-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Issue 6: EBS volume without encryption
resource "aws_ebs_volume" "unencrypted_volume" {
  availability_zone = "us-west-2a"
  size              = 40
  
  # Missing encryption
  encrypted = false
}

# Issue 7: CloudTrail without log validation
resource "aws_cloudtrail" "insecure_trail" {
  name                          = "my-trail"
  s3_bucket_name                = aws_s3_bucket.insecure_bucket.id
  
  # Missing log file validation
  enable_log_file_validation    = false
  
  # Missing KMS encryption
  # Missing CloudWatch Logs integration
}

# Issue 8: ELB with insecure SSL policy
resource "aws_lb_listener" "insecure_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"  # Outdated policy
  certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb" "main" {
  name               = "main-lb"
  internal           = false
  load_balancer_type = "application"
  
  # Missing access logs
  # Missing deletion protection
}

resource "aws_lb_target_group" "main" {
  name     = "main-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678"
}
