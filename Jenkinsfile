pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Set environment variables dynamically based on branch
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.IMAGE_NAME = 'nodemain:v1.0'
                        env.LOGO = 'src/logo_main.svg' 
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.IMAGE_NAME = 'nodedev:v1.0'
                        env.LOGO = 'src/logo_dev.svg'
                    } else {
                        error("Unknown branch: ${env.BRANCH_NAME}")
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm // Fetch branch-specific source code
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    sh "cp ${env.LOGO} src/logo.svg" // Apply branch-specific logo
                    echo "${env.BRANCH_NAME} branch logo applied successfully."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build --build-arg LOGO=${env.LOGO} -t ${env.IMAGE_NAME} ." // Build Docker image
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
                    sh 'docker ps -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker stop' // Stop running containers
                    sh 'docker ps -a -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker rm' // Remove stopped containers
                }
            }
        }

        stage('Deploy') {
            steps {
                sh "docker run -d --name ${env.BRANCH_NAME}_container -p ${env.PORT}:3000 ${env.IMAGE_NAME}" // Deploy container
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
