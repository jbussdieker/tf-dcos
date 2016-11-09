resource "aws_instance" "master" {
  count         = "${var.master_count}"
  ami           = "${var.ami}"
  instance_type = "${var.master_instance_type}"
  key_name      = "${var.key_name}"
  subnet_id     = "${aws_subnet.public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.base.id}",
    "${aws_security_group.dcos.id}",
    "${aws_security_group.master.id}",
  ]

  tags {
    Name    = "master-${count.index}"
    Cluster = "${var.name}"
  }
}

resource "aws_route53_record" "master" {
  count   = "${var.master_count}"
  zone_id = "${aws_route53_zone.internal.zone_id}"
  name    = "master-${count.index}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.master.*.private_ip, count.index)}"]
}

resource "null_resource" "master" {
  count = "${var.master_count}"

  connection {
    host        = "${element(aws_instance.master.*.public_ip, count.index)}"
    user        = "core"
    private_key = "${file("${var.key_path}")}"
  }

  provisioner "file" {
    destination = "/tmp/dcos.sh"
    source      = "${path.module}/scripts/dcos.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo bash /tmp/dcos.sh master master-${count.index} ${aws_instance.bootstrap.private_ip}"]
  }

  triggers {
    script_hash = "${sha256("${file("${path.module}/scripts/dcos.sh")}")}"
    instance_id = "${element(aws_instance.master.*.id, count.index)}"
  }

  depends_on = [
    "null_resource.bootstrap",
  ]
}
