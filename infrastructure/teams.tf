# This file describes the infrastructure needed for a team and loop over it
#

# Master the team
resource "google_compute_instance" "team-master" {
    count = "${var.teams}"
    name = "team${count.index +1}-master"
    machine_type = "g1-small"
    zone = "europe-west1-b"
    tags = ["team${count.index +1}", "master", "salt"]

    disk {
        image = "${var.image}"
    }

    network_interface {
        network = "salt"
        access_config {
            // Ephemeral IP
        }
    }

    metadata {
        grains = <<EOG
roles:
  - master
team: team${count.index + 1}
EOG
        master = "central-master"
    }

    metadata_startup_script = "${file("master-bootstrap.sh")}"

    service_account {
        scopes = ["compute-ro", "storage-ro"]
    }

    depends_on = ["google_compute_instance.root"]
}

resource "google_dns_record_set" "team-master" {
    count = "${var.teams}"
    managed_zone = "${var.zone}"
    name = "team${count.index +1}-master.${var.domain}"
    type = "A"
    ttl = 300
    rrdatas = ["${element(google_compute_instance.team-master.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
    depends_on = ["google_compute_instance.team-master"]
}


# HAProxy of the team
resource "google_compute_instance" "team-haproxy" {
    count = "${var.teams}"
    name = "team${count.index + 1}-haproxy"
    machine_type = "g1-small"
    zone = "europe-west1-b"
    tags = ["team${count.index +1}", "haproxy", "salt", "nat"]

    disk {
        image = "${var.image}"
    }

    network_interface {
        network = "salt"
        /*access_config {
            // Ephemeral IP
        }*/
    }

    metadata {
        grains = <<EOG
roles:
  - haproxy
team: team${count.index + 1}
EOG
        master = "team${count.index + 1}-master"
    }

    metadata_startup_script = "${file("minion-bootstrap.sh")}"

    service_account {
        scopes = ["compute-ro", "storage-ro"]
    }

    depends_on = ["google_compute_instance.root"]
}

# Tomcats of the team
resource "google_compute_instance" "team-tomcat" {
    count = "${var.teams * 2}"
    name = "team${((count.index + 1) % var.teams) + 1}-tomcat${count.index}"
    machine_type = "g1-small"
    zone = "europe-west1-b"
    tags = ["team${((count.index + 1) % var.teams) + 1}", "tomcat", "salt", "nat"]

    disk {
        image = "${var.image}"
    }

    network_interface {
        network = "salt"
        /*access_config {
            // Ephemeral IP
        }*/
    }

    metadata {
        grains = <<EOG
roles:
  - tomcat
team: team${((count.index + 1) % var.teams) + 1}
EOG
        master = "team${((count.index + 1) % var.teams) + 1}-master"
    }

    metadata_startup_script = "${file("minion-bootstrap.sh")}"

    service_account {
        scopes = ["compute-ro", "storage-ro"]
    }

    depends_on = ["google_compute_instance.root"]
}

# Redis of the team
resource "google_compute_instance" "team-redis" {
    count = "${var.teams}"
    name = "team${count.index + 1}-redis"
    machine_type = "g1-small"
    zone = "europe-west1-b"
    tags = ["team${count.index +1}", "redis", "salt", "nat"]

    disk {
        image = "${var.image}"
    }

    network_interface {
        network = "salt"
        /*access_config {
            // Ephemeral IP
        }*/
    }

    metadata {
        grains = <<EOG
roles:
  - redis
team: team${count.index + 1}
EOG
        master = "team${count.index + 1}-master"
    }

    metadata_startup_script = "${file("minion-bootstrap.sh")}"

    service_account {
        scopes = ["compute-ro", "storage-ro"]
    }

    depends_on = ["google_compute_instance.root"]
}

