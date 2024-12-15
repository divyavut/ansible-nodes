
# creates a jenkins server which act as master in this usecase
module "control_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = var.master_name

  instance_type          = "t3.micro"
  vpc_security_group_ids = ["sg-08eed4ca0fd852a9e"]
  subnet_id              = "subnet-0509f144a358e12de"
  ami = data.aws_ami.ami_info.id
  user_data = <<-EOF
              #!/bin/bash
              dnf install ansible -y 
              EOF
 
  # Define the root volume size and type
  root_block_device = [
    {
        volume_size = 20 # GiB
        volume_type = "gp3" # general purpose ssd
        delete_on_termination = true # automatically delete the volumes when the instance is terminated
    }
  ]
  spot_price = "auto"
  tags = {
    Name = var.master_name
  }
}

# creates a jenkins server which act as agent in this usecase
# module "managed_node" {
#   source  = "terraform-aws-modules/ec2-instance/aws"

#   name = var.agent_name

#   instance_type          = "t3.micro"
#   vpc_security_group_ids = ["sg-08eed4ca0fd852a9e"]
#   subnet_id              = "subnet-0509f144a358e12de"
#   ami = data.aws_ami.ami_info.id
#   # Define the root volume size and type
#   root_block_device = [
#     {
#         volume_size = 20 # GiB
#         volume_type = "gp3" # general purpose ssd
#         delete_on_termination = true # automatically delete the volumes when the instance is terminated
#     }
#   ]
#   spot_price = "auto"
#   tags = {
#     Name = var.agent_name
#   }
# }

# Create records for jenkins master, jenkins agent in route 53 
# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 3.0"

#   zone_name = var.zone_name # divyavutakanti.com

#   records = [
#     {
#       name    = "control_node"  # jenkins.divyavutakanti.com
#       type    = "A"
#       ttl     = 1
#       records = [module.control_node.public_ip]
#        allow_overwrite = true
#     },
#     {
#       name    = "managed_node"
#       type    = "A"
#       ttl     = 1
#       records = [module.managed_node.public_ip] # jenkins-agent.divyavutakanti.com
      
#        allow_overwrite = true
#     },
#   ]
# }