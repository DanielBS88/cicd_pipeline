pipeline {
    agent any
    environment {
        // Environment variables depending on the branch
        PORT = BRANCH_NAME == 'main' ? '3000' : '3001'
        IMAGE_NAME = BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh './scripts/test.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Cleanup Containers') {
            steps {
                sh 'docker stop $(docker ps -q) || true'
                sh 'docker rm $(docker ps -a -q) || true'
            }
        }

        stage('Deploy') {
            steps {
                sh "docker run -d --expose ${PORT} -p ${PORT}:3000 ${IMAGE_NAME}"
            }
        }
    }
}
