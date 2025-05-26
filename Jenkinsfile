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
                        env.CONTAINER_NAME = 'main_container'  // Container name for main branch
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.IMAGE_NAME = 'nodedev:v1.0'
                        env.CONTAINER_NAME = 'dev_container'   // Container name for dev branch
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
                    // Replace the default logo with the branch-specific logo
                    sh "cp src/logo_${env.BRANCH_NAME}.svg src/logo.svg"
                    echo "${env.BRANCH_NAME} branch logo applied successfully."
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
                script {
                    // Stop any running containers for this branch
                    sh "docker ps -q --filter \"name=${env.CONTAINER_NAME}\" | xargs -r docker stop"

                    // Remove any stopped containers for this branch
                    sh "docker ps -a -q --filter \"name=${env.CONTAINER_NAME}\" | xargs -r docker rm"
                }
            }
        }

        stage('Deploy') {
            steps {
                // Run the Docker container for the application
                sh "docker run -d --name ${env.CONTAINER_NAME} -p ${env.PORT}:3000 ${env.IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
