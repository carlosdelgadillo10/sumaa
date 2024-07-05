def app
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
                    app = docker.build('docker build -t sumaa .')
                    //app = docker.build("carlosdelgadillo/sumaa")
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
        /*stage('SAST - Bandit') {
            steps {
                sh'''                     
                    python3 -m venv venv
                    . venv/bin/activate
                    bandit -r . -f html -o bandit_report.html
                    '''          
            }
            post {                                                                                                    
                always {
                    archiveArtifacts artifacts: 'bandit_report.html', allowEmptyArchive: true
                }
            }
        }*/

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
/*    post {
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
*/     

   
}

