pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Dynamically set environment variables based on the current branch
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
                // Checkout source code for the branch
                checkout scm
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    // Dynamically handle branch-specific logo files
                    if (env.BRANCH_NAME == 'main') {
                        sh 'cp src/logo_main.svg src/logo.svg'
                        echo 'Using main branch logo.'
                    } else if (env.BRANCH_NAME == 'dev') {
                        sh 'cp src/logo_dev.svg src/logo.svg'
                        echo 'Using dev branch logo.'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image for the application
                sh "docker build -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Cleanup Containers') {
            steps {
                // Stop and remove any previously running containers
                sh 'docker stop $(docker ps -q) || true'
                sh 'docker rm $(docker ps -a -q) || true'
            }
        }

        stage('Deploy') {
            steps {
                // Run the Docker container for the application
                sh "docker run -d --name ${env.BRANCH_NAME}_container -p ${env.PORT}:3000 ${env.IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details!'
        }
    }
}
