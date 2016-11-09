resource "aws_security_group" "base" {
  name        = "base"
  description = "base"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_cidr}"]
  }
}

resource "aws_security_group" "dcos" {
  name        = "dcos"
  description = "dcos"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group" "bootstrap" {
  name        = "bootstrap"
  description = "bootstrap"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.dcos.id}"]
  }
}

resource "aws_security_group" "master" {
  name        = "master"
  description = "master"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_cidr}"]
  }

  ingress {
    from_port   = 8181
    to_port     = 8181
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_cidr}"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.dcos.id}"]
  }
}

resource "aws_security_group" "agent-public" {
  name        = "agent-public"
  description = "agent-public"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.dcos.id}"]
  }
}

resource "aws_security_group" "agent" {
  name        = "agent"
  description = "agent"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.dcos.id}"]
  }
}
