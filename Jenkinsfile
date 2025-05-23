pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.PORT = '3000'
                        env.IMAGE_NAME = 'nodemain:v1.0'
                        env.LOGO = 'src/logo_main.svg'  // Use main branch logo
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.PORT = '3001'
                        env.IMAGE_NAME = 'nodedev:v1.0'
                        env.LOGO = 'src/logo_dev.svg'   // Use dev branch logo
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

        stage('Build Docker Image') {
            steps {
                sh "docker build --build-arg LOGO=${env.LOGO} -t ${env.IMAGE_NAME} ."
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
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
