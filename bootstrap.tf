resource "aws_instance" "bootstrap" {
  ami           = "${var.ami}"
  instance_type = "${var.bootstrap_instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.base.id}",
    "${aws_security_group.bootstrap.id}",
  ]

  tags {
    Name    = "bootstrap"
    Cluster = "${var.name}"
  }
}

resource "aws_route53_record" "bootstrap" {
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "bootstrap"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.bootstrap.*.private_ip, count.index)}"]
}

resource "null_resource" "bootstrap" {
  connection {
    host        = "${aws_instance.bootstrap.public_ip}"
    user        = "core"
    private_key = "${file("${var.key_path}")}"
  }

  provisioner "file" {
    destination = "/tmp/bootstrap.sh"
    source      = "${path.module}/scripts/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo bash /tmp/bootstrap.sh bootstrap ${var.name} ${join(" ", aws_instance.master.*.private_ip)}"]
  }

  triggers {
    script_hash = "${sha256("${file("${path.module}/scripts/bootstrap.sh")}")}"
    instance_id = "${aws_instance.bootstrap.id}"
  }
}
