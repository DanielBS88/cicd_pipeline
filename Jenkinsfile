pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
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
                checkout scm
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    sh '''
                    #!/bin/bash
                    echo "Replacing logo.svg with ${env.LOGO}"
                    cp ${env.LOGO} src/logo.svg
                    '''
                    echo "${env.BRANCH_NAME} branch logo applied successfully."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                #!/bin/bash
                echo "Building Docker image: ${env.IMAGE_NAME}"
                docker build --build-arg LOGO=${env.LOGO} -t ${env.IMAGE_NAME} .
                '''
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
                    echo "Cleaning up containers for branch ${env.BRANCH_NAME}..."
                    sh '''
                    #!/bin/bash
                    for container_id in $(docker ps -q --filter "name=${env.BRANCH_NAME}_container"); do
                        docker stop $container_id || true
                    done
                    for container_id in $(docker ps -a -q --filter "name=${env.BRANCH_NAME}_container"); do
                        docker rm $container_id || true
                    done
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying container for branch: ${env.BRANCH_NAME}, Port: ${env.PORT}"

                    // Handle conflicting containers
                    sh '''
                    #!/bin/bash
                    echo "Cleaning up any conflicting container named ${env.BRANCH_NAME}_container..."
                    if [ $(docker ps -a --filter "name=${env.BRANCH_NAME}_container" -q | wc -l) -gt 0 ]; then
                        for container_id in $(docker ps -a --filter "name=${env.BRANCH_NAME}_container" -q); do
                            echo "Stopping and removing container: $container_id"
                            docker stop $container_id || true
                            docker rm $container_id || true
                        done
                    fi
                    '''

                    // Deploy new container
                    sh '''
                    #!/bin/bash
                    echo "Starting new container: ${env.BRANCH_NAME}_container"
                    docker run -d --name ${env.BRANCH_NAME}_container -p ${env.PORT}:3000 ${env.IMAGE_NAME}
                    '''
                }
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
