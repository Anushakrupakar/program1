    #!/bin/bash
    # install docker and start docker on deploy server
  sudo yum update -y && sudo yum install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ec2-usermod
  