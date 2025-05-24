pipeline {
    agent any

    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Dynamically set environment variables based on the branch
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
                    echo "Configured environment for ${env.BRANCH_NAME}:"
                    echo "PORT=${env.PORT}, IMAGE_NAME=${env.IMAGE_NAME}, LOGO=${env.LOGO}"
                }
            }
        }

        stage('Checkout') {
            steps {
                echo "Checking out the ${env.BRANCH_NAME} branch..."
                checkout scm
            }
        }

        stage('Replace Logo Before Build') {
            steps {
                script {
                    echo "Replacing logo.svg with ${env.LOGO} for branch ${env.BRANCH_NAME}..."
                    
                    // Replace the old logo with the branch-specific logo
                    sh "cp ${env.LOGO} src/logo.svg"

                    // Debug: Verify that src/logo.svg was correctly replaced
                    sh "echo 'Current logo contents after replacement:' && cat src/logo.svg"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${env.IMAGE_NAME} with logo ${env.LOGO}..."
                sh """
                docker build \
                    --build-arg LOGO=${env.LOGO} \
                    -t ${env.IMAGE_NAME} .
                """
            }
        }

        stage('Cleanup Containers') {
            steps {
                script {
                    echo "Cleaning up any running or stopped containers for ${env.BRANCH_NAME}..."

                    // Stop running containers for the branch
                    sh """
                    docker ps -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker stop || true
                    """

                    // Remove any stopped containers for the branch
                    sh """
                    docker ps -a -q --filter "name=${env.BRANCH_NAME}_container" | xargs -r docker rm || true
                    """

                    // Log: Confirm cleanup operation details
                    sh 'docker ps -a --filter "name=${env.BRANCH_NAME}_container"'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying Docker container for ${env.BRANCH_NAME} on port ${env.PORT}..."
                
                // Deploy the Docker container
                sh """
                docker run -d \
                    --name ${env.BRANCH_NAME}_container \
                    -p ${env.PORT}:3000 \
                    ${env.IMAGE_NAME}
                """

                // Debug: Verify running containers after deployment
                sh """
                echo "Verifying running container:"
                docker ps --filter "name=${env.BRANCH_NAME}_container"
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully for branch ${env.BRANCH_NAME}!"
        }

        failure {
            echo "Pipeline failed for branch ${env.BRANCH_NAME}. Check logs for details."
        }
    }
}
