pipeline{
<<<<<<< HEAD
    agent any
=======
    agent none
>>>>>>> f66a6b6733338bf0be7581e380d890d9d7bd3866
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
<<<<<<< HEAD
            steps{
=======
            agent any
            
              steps{
>>>>>>> f66a6b6733338bf0be7581e380d890d9d7bd3866
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
<<<<<<< HEAD
           steps{
=======
            agent {label 'linux_slave'}
              steps{
>>>>>>> f66a6b6733338bf0be7581e380d890d9d7bd3866
                script{
              echo "Building the app"
              echo "building version ${NEW_VERSION}"
              sh 'mvn package'
        }
    }
        }
<<<<<<< HEAD
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
=======
    stage("Deploy"){
      
        steps{
            script{
                echo "Deploying the app"
                echo "Deploying ${NEW_VERSION}"
            }
        }
    }
>>>>>>> f66a6b6733338bf0be7581e380d890d9d7bd3866
    }
}
