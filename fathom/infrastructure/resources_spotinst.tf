provider "spotinst" {
  token   = "${var.spotinst_token}"
  account = "${var.spotinst_account}"
}

resource "spotinst_elastigroup_aws" "instance" {
  name        = "${var.project}.${var.domain} (${var.stage}-spotinst)"
  description = "Fathom instance"
  product     = "Linux/UNIX"

  max_size                      = 1
  min_size                      = 1
  desired_capacity              = 1
  spot_percentage               = 100
  capacity_unit                 = "instance"
  instance_types_ondemand       = "t3.nano"
  instance_types_spot           = ["t3a.nano", "t3.nano"]
  instance_types_preferred_spot = ["t3a.nano"]
  persist_root_device           = true
  persist_block_devices         = true
  persist_private_ip            = false
  block_devices_mode            = "reattach"

  region      = "eu-west-1"
  subnet_ids  = ["${data.aws_subnet_ids.selected.ids}"]
  elastic_ips = ["${aws_eip.public_ip.id}"]

  image_id        = "${data.aws_ami.fathom-ubuntu-18.id}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.front.id}"]

  orientation          = "costOriented"
  fallback_to_ondemand = true

  revert_to_spot = [
    {
      perform_at = "always"
    },
  ]

  stateful_deallocation {
    should_delete_images             = false
    should_delete_network_interfaces = false
    should_delete_volumes            = false
    should_delete_snapshots          = false
  }

  tags = [
    {
      key   = "Env"
      value = "${var.stage}"
    },
    {
      key   = "Name"
      value = "${var.project}.${var.domain} (${var.stage}-spotinst)"
    },
    {
      key   = "Spotinst"
      value = "true"
    },
    {
      key   = "Project"
      value = "${var.project}"
    },
  ]

  lifecycle {
    ignore_changes = [
      "desired_capacity",
      "image_id",
    ]
  }

  user_data = <<-EOF
    #!/bin/bash
    /usr/local/bin/fathom -c /opt/fathom/.env user add --email=${var.fathom_email} --password=${var.fathom_password}
  EOF
}
