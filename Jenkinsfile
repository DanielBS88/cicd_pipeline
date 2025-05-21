pipeline {
    agent any
<<<<<<< HEAD

    environment {
=======
    environment {
        // Environment variables depending on the branch
>>>>>>> main
        PORT = BRANCH_NAME == 'main' ? '3000' : '3001'
        IMAGE_NAME = BRANCH_NAME == 'main' ? 'nodemain:v1.0' : 'nodedev:v1.0'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

<<<<<<< HEAD
        stage('Setup Node.js') {
            steps {
                script {
                    echo "Using NodeJS version: NodeJS-7.8.0"
                }
            }
        }

=======
>>>>>>> main
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

<<<<<<< HEAD
        stage('Handle Branch-Specific Logo') {
            steps {
                script {
                    if (BRANCH_NAME == 'main') {
                        sh 'cp src/logo_main.svg src/logo.svg'
                    } else if (BRANCH_NAME == 'dev') {
                        sh 'cp src/logo_dev.svg src/logo.svg'
                    }
                }
            }
        }

=======
>>>>>>> main
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

<<<<<<< HEAD
        stage('Deploy Application') {
=======
        stage('Deploy') {
>>>>>>> main
            steps {
                sh "docker run -d --expose ${PORT} -p ${PORT}:3000 ${IMAGE_NAME}"
            }
        }
    }
<<<<<<< HEAD

    post {
        success {
            echo 'Pipeline executed successfully.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
=======
>>>>>>> main
}
