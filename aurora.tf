resource "aws_rds_cluster" "aurora_psql_cluster" {
  cluster_identifier     = "aurora-psql-cluster"
  engine                 = "aurora-postgresql"
  master_username        = var.aurora_admin_username
  master_password        = var.aurora_admin_password
  db_subnet_group_name   = aws_db_subnet_group.aurora_private_subnets.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "aurora-psql-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora-rds-instance-0" {
  cluster_identifier = aws_rds_cluster.aurora_psql_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_psql_cluster.engine
  engine_version     = "15.4"

  availability_zone = var.azs[0]
  tags = {
    Name = "aurora-instance"
  }
}


resource "aws_rds_cluster_instance" "aurora-rds-instance-1" {
  cluster_identifier = aws_rds_cluster.aurora_psql_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_psql_cluster.engine
  engine_version     = "15.4"

  availability_zone = var.azs[1]
  tags = {
    Name = "aurora-instance"
  }
}

resource "aws_rds_cluster_instance" "aurora-rds-instance-2" {
  cluster_identifier = aws_rds_cluster.aurora_psql_cluster.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_psql_cluster.engine
  engine_version     = "15.4"

  availability_zone = var.azs[2]
  tags = {
    Name = "aurora-instance"
  }
}

