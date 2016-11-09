resource "aws_instance" "agent-public" {
  count         = "${var.agent_public_count}"
  ami           = "${var.ami}"
  instance_type = "${var.agent_public_instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.base.id}",
    "${aws_security_group.dcos.id}",
    "${aws_security_group.agent-public.id}",
  ]

  tags {
    Name    = "agent-public-${count.index}"
    Cluster = "${var.name}"
  }
}

resource "aws_route53_record" "agent-public" {
  count   = "${var.agent_public_count}"
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "agent-public-${count.index}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.agent-public.*.private_ip, count.index)}"]
}

resource "null_resource" "agent-public" {
  count = "${var.agent_public_count}"

  connection {
    host        = "${element(aws_instance.agent-public.*.public_ip, count.index)}"
    user        = "core"
    private_key = "${file("${var.key_path}")}"
  }

  provisioner "file" {
    destination = "/tmp/dcos.sh"
    source      = "${path.module}/scripts/dcos.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo bash /tmp/dcos.sh slave_public agent-public-${count.index} ${aws_instance.bootstrap.private_ip}"]
  }

  triggers {
    script_hash = "${sha256("${file("${path.module}/scripts/dcos.sh")}")}"
    instance_id = "${element(aws_instance.agent-public.*.id, count.index)}"
  }

  depends_on = [
    "null_resource.master",
  ]
}
