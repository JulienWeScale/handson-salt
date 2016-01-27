# This file is only intended to own parameters that can be customized for the hands on

variable "image" {
    # Custom centos7 with updates
    default = "centos7-20161601"
}

variable "teams" {
    # Custom centos7 with updates
    default = 1
}

variable "zone" {
    default = "gcp-wescale-zone"
}

variable "domain" {
    default = "gcp.wescale.fr."
}