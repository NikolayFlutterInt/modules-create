variable "cidr_block" {
  default = {
    vpc_route     = "172.16.0.0/16"
    public_1      = "172.16.1.0/24"
    public_2      = "172.16.3.0/24"
    private_1     = "172.16.4.0/24"
    private_2     = "172.16.5.0/24"
    default_route = "0.0.0.0/0"
    trusted_ip    = "91.211.97.132/32"
  }
}

variable "availability_zone" {
  default = {
    availability_zone_1 = "eu-west-1a"
    availability_zone_2 = "eu-west-1b"
  }
}


variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0e23c576dacf2e3df"
}
