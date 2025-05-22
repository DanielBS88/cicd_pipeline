pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
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
                checkout scm
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    // Dynamically replace logo file
                    if (env.BRANCH_NAME == 'main') {
                        sh 'cp src/logo_main.svg src/logo.svg'
                        echo 'Main branch logo applied.'
                    } else if (env.BRANCH_NAME == 'dev') {
                        sh 'cp src/logo_dev.svg src/logo.svg'
                        echo 'Dev branch logo applied.'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
                    // Stop and remove any existing containers
                    sh 'docker ps -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker stop'
                    sh 'docker ps -a -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker rm'
                }
            }
        }

        stage('Deploy') {
            steps {
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
