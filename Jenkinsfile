pipeline{

    agent any

    tools{
        jdk 'myjava'
        maven 'mymaven'
      
    }
    environment{
        NEW_VERSION='1.4.0'
    }
    stages{
        stage("COMPILE"){
           
            steps{
                script{
                     echo "Compiling the code"
                     git 'https://github.com/preethid/addressbook.git'
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
                sh 'sudo docker build -t devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER .'
                  sh 'sudo docker login -u $USERNAME -p $PASSWORD'
                 sh 'sudo docker push devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
                }
            }
        }
    }
    stage("Deploydockercontainer"){
        steps{
            script{
              echo "Deploying the app"
                def ShellCmd = "bash ./remote-server.sh"
                 sshagent(['deploy-server-ssh-key']) {
                      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                           sh "scp remote-server.sh ${ec2Instance}:/home/ec2-user"
                      sh "ssh -o StrictHostKeyChecking=no ec2-user@13.235.115.181 ${ShellCmd}"
                   }
                  }
                }
            }
        }
    }
        }
