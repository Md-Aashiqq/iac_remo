
variable "public_key_path" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3l8YJ/iQwpquJpPjKDNRzD3TNMHoPqJq1U20g562iI0c89pSTkVOQ9WcKrlUOvB32ltN4tbTHK7C9Xseywn3EaABFy+NhQxccLethKhLyIQl3W/MwCFIlb2YLvj4fPIDeqmlHLMTU+78OIWjjf8VG5IEmUnZXNy75xUJ5XRzN8dpS3Buazm4VmouJzwPbJ7McLZJhjmm1V8wZH8axhwflqrOPYvatdmD5Ny1k4zzyL9yJfcVeb8ufJVvDkOZanFGyVmgDum9V34HVRArY8oY+3xNXx0CY4XlAb0iG+Li8xGY+NzCrCe09duX5d97d1XWYzdoFvZzuXwZ08xmfq2PEO3a1+MkUD0rMy4Ct4JFypdwuvQUKzpAgXsfMIftXNWM4J3fmlpkz7PAvYd2l2gHqP13NlCdKilM/BFNosruiBvOyPCPYjBzhjuwBrUu54XP5iPByyH9XrsHA1b1nTo22nwdovKVOoR7z5KfULHXv9F5fzSae27P+aKfy1BcKeSs= mohammedashick@haji.local"
}

variable "vpc_name" {
  default = "Iac_LAMP_VPC"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_name" {
  default = "Iac_LAMP_SUBNET"
}

variable "public_subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "private_subnet_name" {
   default = "Iac_LAMP_PRIVATE_SUBNET"
}

variable "private_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}