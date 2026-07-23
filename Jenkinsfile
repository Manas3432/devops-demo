pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = 'manas521/devops-demo'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push $IMAGE_NAME:latest'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    docker stop devops-demo-app || true
                    docker rm devops-demo-app || true
                    docker run -d --name devops-demo-app -p 9090:8080 $IMAGE_NAME:latest
                '''
            }
        }

    }

    post {
        success {
            echo 'Pipeline completed successfully — app deployed!'
        }
        failure {
            echo 'Pipeline failed — check the logs above.'
        }
    }
}
