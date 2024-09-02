pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    docker.build('calculator-app', '-f dockerfile .')
                }
            }
        }
        stage('Run Unit Tests') {
            steps {
                script {
                    // Run unit tests inside the Docker container
                    docker.image('calculator-app').inside {
                        sh 'python -m unittest discover tests'
                    }
                }
            }
        }
        stage('Run Application') {
            steps {
                script {
                    // Run the Docker container to execute the application
                    docker.image('calculator-app').inside {
                        // Replace with the actual command to run the application
                        sh 'python src/calculator.py add 5 3'
                    }
                }
            }
        }
        
        
    }
}
