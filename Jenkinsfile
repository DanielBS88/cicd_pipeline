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
                // Checkout source code for the branch
                checkout scm
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    // Replace the default logo with the branch-specific logo
                    sh "cp ${env.LOGO} src/logo.svg"
                    echo "${env.BRANCH_NAME} branch logo applied."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image for the application, passing the LOGO argument
                sh "docker build --build-arg LOGO=${env.LOGO} -t ${env.IMAGE_NAME} ."
            }
        }

	 stage('Cleanup Containers') {
             steps {
                 script {
                     // Stop and remove containers specific to the current branch
                     sh "docker ps -q --filter name=${env.BRANCH_NAME}_container | xargs -r docker stop"
                     sh "docker ps -a -q --filter name=${env.BRANCH_NAME}_container | xargs -r docker rm"
            }
         }
      }
#        stage('Cleanup Containers') {#            steps {
#                script {
#                    // Stop any running containers for this branch
#                    sh 'docker ps -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker stop'\
#                    // Remove any stopped containers for this branch
#                    sh 'docker ps -a -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker rm'
#                }
#            }
#        }

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
