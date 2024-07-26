def app
pipeline {
    agent any
    environment {
        // Variables de entorno para Docker
        DOCKER_IMAGE = "carlosdelgadillo/sumaa"
        DOCKER_TAG = "latest"
        CONTAINER_NAME = 'sumaa' 
        DOCKERHUB_CREDENTIALS_ID = "docker-hub-credentials"
        DOCKERHUB_REPO = "carlosdelgadillo/sumaa"
        KUBECTL_CONFIG = '/home/carlosd/.kube/config' // Ajusta según tu configuración
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
                    // Construye la imagen Docker
                    //sh "docker build -t ${DOCKER_IMAGE} ."
                    app = docker.build("${DOCKER_IMAGE}")
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
                        pip install fastapi uvicorn
                        pip install pytest pytest-cov
                        pytest --cov=app --cov-report=xml:coverage.xml --cov-report=term-missing \
                            --junit-xml=pytest-report.xml
                    '''
                }
            }
        }
        stage('Deploy'){
            steps{
                script{
                    //sh "docker.stop ${DOCKER_IMAGE}"
                    //sh "docker.rmi ${DOCKER_IMAGE} -f"
                    //sh "docker run -d -p 8085:8085 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    //sh 'docker run -d -p 8001:8001 sumaa'
                    // sh 'docker run -d -p 8001:8001 carlosdelgadillo/sumaa'
                    // Verifica si el contenedor ya está en ejecución
                    // Verifica si el contenedor ya está en ejecución
                    def containerRunning = sh (
                        script: "docker ps --filter 'name=${CONTAINER_NAME}' --format '{{.Names}}' | grep ${CONTAINER_NAME}",
                        returnStatus: true
                    )
                    
                    if (containerRunning != 0) {
                        sh "docker run -d --name ${CONTAINER_NAME} -p 8085:8085 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    } else {
                        echo 'El contenedor ya está en ejecución, no se necesita ejecutar nuevamente.'
                    }
                }
            }
        }
        /*stage(‘Deploy to Minikube’) {
            steps {
                script{
                    sh "kubectl apply -f my-react-deployments.yaml"
                }
            }*/
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

        /*stage('SonarQube Analysis') {
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
        }*/
        stage('Push image') {
            steps {
                script {
                    // Inicia sesión en DockerHub
                    //withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        //sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                        // Etiqueta y sube la imagen a DockerHub
                        //sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKERHUB_REPO}:${DOCKER_TAG}"
                        //sh "docker push ${DOCKERHUB_REPO}:${DOCKER_TAG}"
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
        stage('Apply Kubernetes Files') {
            steps {
                withKubeConfig([credentialsId: 'mykubeconfig']) {
                // Nota para alkcanzar el archivo le decimos que a la altura.
                //Instalar plugin kubernetes CLI
                sh 'kubectl apply -f ./k8s/namespace.yaml'
                sh 'kubectl apply -f ./k8s/deployment.yaml'
                sh 'kubectl apply -f ./k8s/service.yaml'
                sh 'kubectl apply -f ./k8s/ingress.yaml'
                // Verifica si el servicio ya existe antes de exponerlo
                    def serviceExists = sh (
                        script: 'kubectl -n suma get service suma-deployment --ignore-not-found',
                        returnStatus: true
                    )
                    
                    if (serviceExists != 0) {
                        sh 'kubectl -n suma expose deployment suma-deployment --type=NodePort --port=8004'
                    } else {
                        echo 'El servicio suma-deployment ya existe, no se necesita exponerlo nuevamente.'
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

