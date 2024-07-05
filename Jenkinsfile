def app
pipeline {
    agent any
    environment {
        ZAP_HOME = '/usr/local/bin/owasp-zap' // Reemplaza con la ruta real
    }

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
                    app = sh 'docker build -t sumaa .'
                    //zapp = docker.build("carlosdelgadillo/sumaa")
                }
            }
        }

        stage('Run Tests and Coverage') {
            steps {
                script {
                    // Ejecutar pruebas y cobertura con pytest
                    sh '''
                        pytest --cov=app --cov-report=xml:coverage.xml --cov-report=term-missing \
                            --junit-xml=pytest-report.xml
                    '''
                }
            }
        }
        stage('Deploy'){
            steps{
                script{
                    sh 'docker run -d -p 8001:8001 carlosdelgadillo/sumaa'
                }
            }
        }
        stage('DAST - OWASP ZAP') {
            steps {
                script {
                    // Inicia ZAP en modo demonio
                    sh "${env.ZAP_HOME}/zap.sh -daemon -port 8090 -host 0.0.0.0 -config api.disablekey=true"
                    // Espera a que OWASP ZAP inicie
                    sleep(time: 10, unit: 'SECONDS')
                    // Escanea la aplicación
                    sh "${env.ZAP_HOME}/zap-cli quick-scan -t http://localhost:8000"
                    // Genera un reporte HTML
                    sh "${env.ZAP_HOME}/zap-cli report -o zap_report.html -f html"
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'zap_report.html', allowEmptyArchive: true
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
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
        
    }
    post {
        failure {
            emailext (
                subject: "BUILD FAILED: ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                body: """
                    <p><b>El proyecto ${env.JOB_NAME} #${env.BUILD_NUMBER} ha fallado.</b></p>
                    <p>Ver detalles en: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                    """,
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: "carlos.degadillo102003@gmail.com"
            )
        }
    }
        

   
}

