
resource "proxmox_vm_qemu" "ubuntu_vm" {
  # Basic VM Configuration
  vmid        = 100
  name        = "test-terraform0"
  target_node = "kube-lab"
  agent       = 1
  onboot      = true

  # Hardware Configuration
  cpu {
    cores = 2
  }
  memory = 1024
  scsihw = "virtio-scsi-pci"

  # Template Configuration
  clone = "ubuntu-2404-cloudinit"

  # Boot Configuration
  boot     = "order=scsi0;ide1"
  vm_state = "running"

  # Cloud-Init Configuration
  ciupgrade  = true
  nameserver = "1.1.1.1 8.8.8.8"
  ipconfig0  = "ip=dhcp"
  skip_ipv6  = true
  ciuser     = "root"
  cipassword = "12345678"
  # sshkeys    = file("~/.ssh/id_rsa.pub")  # Uncomment and use SSH keys instead of password

  # Disk Configuration
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "vz2"
          size    = "50G"
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = "vz2"
        }
      }
    }
  }

  # Network Configuration
  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Serial Console for Debugging
  serial {
    id = 0
  }

  # Lifecycle Management
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
