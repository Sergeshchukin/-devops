terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("~/key.json")
  cloud_id  = "b1geel521fm744vd41j3"
  folder_id = "b1g773nv27nu15jgceue"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_target_group" "my_tg" {
  name = "test-group"

  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
    address   = module.instance_1.internal_ip_address_vm
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
    address   = module.instance_2.internal_ip_address_vm
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet1.id
    address   = module.instance_3.internal_ip_address_vm
  }
}


module "instance_1" {
  my-name               = "k8s-master"
  source                = "./modules/instance"
  instance_family_image = "ubuntu-2204-lts"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  vpc_subnet_zone       = yandex_vpc_subnet.subnet1.zone
}

module "instance_2" {
  my-name               = "k8s-app"
  source                = "./modules/instance"
  instance_family_image = "ubuntu-2204-lts"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  vpc_subnet_zone       = yandex_vpc_subnet.subnet1.zone
}

module "instance_3" {
  my-name               = "srv"
  source                = "./modules/instance"
  instance_family_image = "ubuntu-2204-lts"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
  vpc_subnet_zone       = yandex_vpc_subnet.subnet1.zone
}

