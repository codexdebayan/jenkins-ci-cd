pipeline {
    agent {
        docker {
            image 'python:3.9-slim'
            args '-v /var/run/docker.sock:/var/run/docker.sock -v ${WORKSPACE}:/app -w /app'  // Use /app as the working directory inside the container
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your repository
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install the dependencies listed in the requirements.txt inside the container
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile located in /app (container)
                    docker.build('calculator-app', '-f dockerfile .')
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    // Run the unit tests inside the Docker container
                    docker.image('calculator-app').inside {
                        sh 'python -m unittest discover tests'
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    // Run the application inside the Docker container
                    docker.image('calculator-app').inside {
                        sh 'python src/calculator.py add 5 3'
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Optionally, remove the Docker image after the pipeline completes
                    sh 'docker rmi calculator-app || true'
                }
            }
        }
    }
}
