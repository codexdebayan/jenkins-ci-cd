pipeline { 

    agent {
        docker {
            image 'python:3.8-slim'
            args '-v /var/lib/docker:/var/lib/docker -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

 

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

                    // Pass any arguments to the calculator script (e.g., add 5 3) 

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

 

    post { 

        always { 

            // Clean up unused Docker resources after the build 

            script { 

                sh 'docker system prune -f' 

            } 

        } 

    } 

} 