data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "New Cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "VMFS01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Template-doron"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "resource_pool" {
  name          = "Doron_pool"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-provisioned-vm"
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 12288
  guest_id = data.vsphere_virtual_machine.template.guest_id

  firmware = "efi"

  network_interface {
    adapter_type = "e1000e"
    network_id   = data.vsphere_network.network.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name  = "terraform-vm"
        admin_password = "Aa123456"
        time_zone      = 135
      }
      network_interface {
        ipv4_address    = "10.160.11.38"
        ipv4_netmask    = 24
        dns_server_list = ["10.160.11.23", "8.8.8.8"]
      }
      ipv4_gateway = "10.160.11.254"

    }
  }

  disk {
    label            = "disk0"
    size             = 90
    eagerly_scrub    = false
    thin_provisioned = true
  }
}

