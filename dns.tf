resource "aws_route53_zone" "internal" {
  name   = "${var.name}.local"
  vpc_id = "${aws_vpc.main.id}"
}
