resource "aws_launch_template" "app_launch_template" {

  name_prefix   = "train-app-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e
apt update -y
apt install docker.io -y
systemctl enable docker
systemctl start docker

docker pull rajshreec/train-app:${var.image_tag}
docker run -d -p 80:3000 rajshreec/train-app:${var.image_tag}
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Application-Server"
    }
  }
}
