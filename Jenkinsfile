pipeline {
    agent any  // Use 'any' agent first, then specify docker for stages
    environment {
        APP_NAME = 'calculator-app'
        DOCKERFILE_PATH = 'dockerfile'
        TEST_COMMAND = 'python -m unittest discover tests'
        RUN_COMMAND = 'python src/calculator.py add 5 3'
    }

    stages {
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'python:3.8-slim' // Define the Docker image here
                    args '-v /var/lib/docker:/var/lib/docker -v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    docker.build("${env.APP_NAME}", "-f ${env.DOCKERFILE_PATH} .")
                }
            }
        }
        stage('Run Unit Tests') {
            steps {
                script {
                    // Run unit tests inside the Docker container
                    docker.image("${env.APP_NAME}").inside {
                        sh "${env.TEST_COMMAND}"
                    }
                }
            }
        }
        stage('Run Application') {
            steps {
                script {
                    // Run the Docker container to execute the application
                    docker.image("${env.APP_NAME}").inside {
                        sh "${env.RUN_COMMAND}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up unused Docker resources after the build
            script {
                sh 'docker system prune -f'
            }
        }
        failure {
            script {
                echo 'The build has failed. Check logs for more details.'
            }
        }
    }
}
