pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS = credentials('github-token') // ID configurado en Jenkins para el token de GitHub
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credential') // ID configurado en Jenkins para DockerHub
        DOCKER_IMAGE = "carlosdelgadillo/web" // Reemplaza "tu_usuario/tu_microservicio" con tu nombre de usuario e imagen
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git url: 'https://github.com/carlosdelgadillo10/sumaaa.git', credentialsId: 'github-token'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
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
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credential') {
                        dockerImage.push("${env.BUILD_ID}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        
    }

    post {
        always {
            // Limpieza después de la ejecución
            deleteDir()
        }
    }
        

   
}

