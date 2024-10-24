provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "password"
  vsphere_server = "1.1.1.1"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
