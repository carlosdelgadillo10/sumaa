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
                    // Construir imagen Docker y asignar a la variable global
                    env.DOCKER_IMAGE = docker.build("carlosdelgadillo/sumaa")
                }
            }
        }
        stage('Setup Python Environment') {
            steps {
                script {
                    // Instalación de dependencias en un entorno virtual
                    sh 'python3 -m venv venv'
                }
            }
        }

        stage('Run Tests and Coverage') {
            steps {
                script {
                    // Ejecutar pruebas y cobertura con pytest
                    sh '''
                        . venv/bin/activate
                        export PYTHONPATH=$PWD
                        pytest --cov=app --cov-report=xml:coverage.xml --cov-report=term-missing \
                            --junit-xml=pytest-report.xml
                    '''
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'

                    // Ejecución de análisis SonarQube
                    withSonarQubeEnv('server-sonar') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=suma-fastapi \
                            -Dsonar.projectName='Mi Proyecto Python' \
                            -Dsonar.sources=app \
                            -Dsonar.tests=tests \
                            -Dsonar.sourceEncoding=UTF-8 \
                            -Dsonar.python.coverage.reportPaths=coverage.xml \
                            -Dsonar.projectVersion=${env.BUILD_NUMBER}
                        """
                    }
                }
            }
        }
        stage('Push image') {
            steps {
                script {
                        // Utilizar la imagen construida en 'Build image' para el push
                        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                            env.DOCKER_IMAGE.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        
        } 
    }
}

