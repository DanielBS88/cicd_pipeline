pipeline {
    agent any

    environment {
        // Dynamic environment variables will be defined later in a script block
    }

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Set Dynamic ENV variables based on the branch
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
                // Checkout source code from the branch
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Using npm to install dependencies
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                // Run the test script to validate the application
                sh './scripts/test.sh'
            }
        }

        stage('Handle Branch-Specific Logo') {
            steps {
                script {
                    // Replace logo.svg based on the branch dynamically
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
                // Build Docker image based on branch
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
                // Run the Docker container
                sh "docker run -d --expose ${env.PORT} -p ${env.PORT}:3000 ${env.IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
