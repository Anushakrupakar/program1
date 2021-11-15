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
            agent {label 'linux_slave'}
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

            agent {label 'linux_slave'}
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
               withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                sh 'sudosudo docker build -t devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER .'
    sh 'sudo docker login -u $USERNAME -p $PASSWORD'
    sh 'sudo docker push devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
    
            }}
        }
    }
    stage("Deploydockercontainer"){
        echo "Deploying the app"
        sh 'sudo docker run -itd -P devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
    }

    }
}
