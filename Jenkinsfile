pipeline {
    agent any

    environment {
        // Static ENV values can be declared here
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Set Dynamic ENV variables depending on the branch
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.IMAGE_NAME = 'nodemain:v1.0'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.IMAGE_NAME = 'nodedev:v1.0'
                    } else {
                        error("Unknown branch: ${env.BRANCH_NAME}")
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                // Checkout the code for the branch
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Install dependencies using npm
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                // Execute the test script
                sh './scripts/test.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image with the computed IMAGE_NAME
                sh "docker build -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Cleanup Containers') {
            steps {
                // Cleanup any previously running containers
                sh 'docker stop $(docker ps -q) || true'
                sh 'docker rm $(docker ps -a -q) || true'
            }
        }

        stage('Deploy Application') {
            steps {
                // Deploy the container on the computed PORT
                sh "docker run -d --expose ${env.PORT} -p ${env.PORT}:3000 ${env.IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
