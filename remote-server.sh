sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo docker login -u $USERNAME -p $PASSWORD
sudo docker run -itd -p 8000:80 devopstrainer/java-mvn-repos:$BUILDNUMBER
