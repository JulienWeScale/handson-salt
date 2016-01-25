

/*
gcp.wescale.fr.	NS	21600
ns-cloud-b1.googledomains.com.
ns-cloud-b2.googledomains.com.
ns-cloud-b3.googledomains.com.
ns-cloud-b4.googledomains.com.
Nom DNS Sous-domaine de la zone DNS


[gcp.wescale.fr.] SOA ns-cloud-b1.googledomains.com. dns-admin.google.com. 0 21600 3600 1209600 300

*/

/*resource "google_dns_managed_zone" "gcp" {
    name = "gcp-wescale-fr-zone"
    dns_name = "gcp.wescale.fr."
    description = "Dedicated zone for gcp hosting"
}*/
/*

resource "google_dns_record_set" "gandhi" {
    managed_zone = "${google_dns_managed_zone.gcp.name}"
    name = ""
    type = "SOA"
    ttl = 21600
    rrdatas = ["ns-cloud-b1.googledomains.com. dns-admin.google.com. 0 21600 3600 1209600 300"]
    depends_on = ["google_dns_managed_zone.gcp"]
}
*/

