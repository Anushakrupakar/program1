pipeline{
    agent any
    tools{
        jdk 'myjava'
        maven 'mymaven'
    }
    environment{
       APP_NAME='java-mvn-app'
       IMAGE_NAME=$BUILD_NUMBER
    }
        parameters{
        choice(name:'VERSION',choices:['1.1.0','1.2.0','1.3.0'],description:'version of the code')
        booleanParam(name: 'executeTests',defaultValue: true,description:'tc validity')
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
        stage("UNITTEST"){
           
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps{
                script{
                    echo "Testing the code"
                    sh 'mvn test'
                }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
         stage("PACKAGE"){
           
           
            steps{
                script{
                    echo "Packaging the code"
                    sh 'mvn package'
                }
            }
        }
         stage("BUILD THE DOCKER IMAGE"){
         
            
            steps{
                script{
                    echo "BUILDING THE DOCKER IMAGE"
                    echo "Deploying version ${params.VERSION}"
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'sudo docker build -t devopstrainer/java-mvn-privaterepo:${IMAGE_NAME} .'
                        sh 'sudo sudo docker login -u $USER -p $PASS'
                        sh 'sudo docker push devopstrainer/java-mvn-privaterepo:${IMAGE_NAME}'
                }
            }
        }
         }
        stage("DEPLOY"){         
            environment {
               AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
               AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                   echo 'deploying docker image...'
                  sh 'sudo /usr/local/bin/kubectl create -f '
                }
            }
        }
}
    }
