pipeline{
    agent any
    tools{
        jdk 'myjava'
        maven 'mymaven'
          }
    environment{
        NEW_VERSION='1.4.0'
        IMAGE = 'devopstrainer/java-mvn-privaterepos'
    }
    stages{
        stage("COMPILE"){
        steps{
                script{
                     echo "Compiling the code"
                     sh 'mvn compile'
                }
            }
                    }
        stage("UnitTest"){
          steps{
                script{
             echo "Run the unit test"
             sh 'mvn test'
        }
              }
              post{
                  always{
                      junit 'target/surefire-reports/*.xml'
                  }
              }
        }
        stage("Package"){
              steps{
                script{
              echo "Building the app"
              echo "building version ${NEW_VERSION}"
              sh 'mvn package'
        }
              }
        }
    stage("Builddockerimage"){      
        steps{
            script{
                echo "Containerising the app"
                sh 'sudo yum install docker -y'
                sh 'sudo systemctl start docker'
               withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                sh 'sudo docker build -t ${IMAGE}:$BUILD_NUMBER .'
                  sh 'sudo docker login -u $USERNAME -p $PASSWORD'
                 sh 'sudo docker push $IMAGE:$BUILD_NUMBER'
                }
            }
        }
    }
    stage("Provision deploy server"){
        environment{
            AWS_ACCESS_KEY_ID =credentials("jenkins_aws_access_key_id")
            AWS_SECRET_ACCESS_KEY=credentials("jenkins_aws_secret_access_key")
        }
        steps{
            script{
                dir('terraform'){
                    sh "terraform init"
                    sh "terraform apply --auto-approve" 
                     EC2_PUBLIC_IP = sh(
                     script: "terraform output ec2-ip",
                     returnStdout: true
                   ).trim()
                }
          }
        }   
         }
    stage("Deploydockercontainer"){
        steps{
            script{
                echo "Waiting for ec2 instance to initialise"
             sleep(time: 90, unit: "SECONDS")
              echo "Deploying the app to ec2-instance provisioned bt TF"
              echo "${EC2_PUBLIC_IP}"
               def ShellCmd= "sudo docker run -itd -P devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER"
               sshagent(['deploy-server-ssh-key']) {
                      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} 'sudo docker login -u $USERNAME -p $PASSWORD'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP}  ${ShellCmd}"
                          sh "terraform destroy --auto-approve"
                      }
                  }
                }
            }
        }
    }
        }
