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
                    sh "cp ${env.LOGO} src/logo.svg"
                    echo "${env.BRANCH_NAME} branch logo applied successfully."
                }
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
                    echo "Cleaning up any running or stopped containers for ${env.BRANCH_NAME}..."

                    // Stop running containers
                    sh '''
                    docker ps -q --filter "name=${env.BRANCH_NAME}_container" | while read container_id; do
                        if [ ! -z "$container_id" ]; then
                            echo "Stopping container: $container_id"
                            docker stop $container_id || true
                        fi
                    done
                    '''

                    // Remove stopped containers
                    sh '''
                    docker ps -a -q --filter "name=${env.BRANCH_NAME}_container" | while read container_id; do
                        if [ ! -z "$container_id" ]; then
                            echo "Removing container: $container_id"
                            docker rm $container_id || true
                        fi
                    done
                    '''

                    // Debugging: List remaining containers
                    sh '''
                    docker ps -a --filter "name=${env.BRANCH_NAME}_container"
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying Docker container for ${env.BRANCH_NAME} on port ${env.PORT}..."

                    // Remove conflicting containers
                    sh '''
                    docker ps -a --filter "name=${env.BRANCH_NAME}_container" -q | while read container_id; do
                        echo "Removing conflicting container: $container_id"
                        docker rm -f $container_id || true
                    done
                    '''

                    // Deploy the new container
                    sh '''
                    docker run -d \
                        --name ${env.BRANCH_NAME}_container \
                        -p ${env.PORT}:3000 \
                        ${env.IMAGE_NAME}
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
