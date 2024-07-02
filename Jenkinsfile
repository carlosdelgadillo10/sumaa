pipeline {
    agent any

    stages {
        stage('Clone repository') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build image') {
            steps {
                script {
                    // Construir imagen Docker
                    def app = docker.build("carlosdelgadillo/sumaa")
                }
            }
        }

   
}
}
