pipeline {
    agent any

    stages {
        stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        script {
            app = docker.build("carlosdelgadillo/sumaa")
        }
    }

        
}
}
