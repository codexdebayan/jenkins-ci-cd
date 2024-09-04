pipeline {
    agent {
        docker {
            image 'docker:20.10.7-dind' // Docker-in-Docker image
            args '--privileged -v /var/lib/docker:/var/lib/docker -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        APP_NAME = 'calculator-app'
        DOCKERFILE_PATH = 'dockerfile'
        TEST_COMMAND = 'python -m unittest discover tests'
        RUN_COMMAND = 'python src/calculator.py add 5 3'
    }

    stages {
        stage('Start Docker') {
            steps {
                script {
                    // Start the Docker service
                    sh 'dockerd-entrypoint.sh &'
                    sh 'sleep 10' // Wait for Docker to initialize
                }
            }
        }
        stage('Build Docker Image') {
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
        stage('Clean Up') {
            steps {
                script {
                    // Optionally, remove the Docker image after the pipeline completes
                    sh "docker rmi ${env.APP_NAME} || true"
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
