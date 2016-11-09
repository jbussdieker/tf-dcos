resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "dcos.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name = "${var.name}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
}
