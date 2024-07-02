pipeline {
    agent any

    stages {
        stage('Clone repository') 
            steps{
                script{
                      checkout scm
                }
            }
      
    }

        stage('Build image') {
            steps{
                script {
                app = docker.build("carlosdelgadillo/sumaa")
            }
            }
            
        }

        
}
