resource "aws_instance" "jump_box" {
  ami = "ami-0a3f5ff1cb905da33"
  instance_type = "t2.micro"
  key_name      = "lyit_key"

  subnet_id              = aws_subnet.pub_subnet.id
  vpc_security_group_ids = [aws_security_group.general_sg.id, aws_security_group.bastion_sg.id]

  tags = {
    Name  = var.iam_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}

resource "aws_instance" "app_instance" {
  ami = "ami-0a3f5ff1cb905da33"
  instance_type = "t2.micro"
  key_name      = "lyit_key"

  subnet_id              = aws_subnet.prv_subnet.id
  vpc_security_group_ids = [aws_security_group.general_sg.id, aws_security_group.app_sg.id]

  tags = {
    Name  = var.iam_cdc_lyit
    Owner = var.owner_name
    proj  = "phoenix"
  }
}