provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "D630@bynet"
  vsphere_server = "10.160.11.234"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
