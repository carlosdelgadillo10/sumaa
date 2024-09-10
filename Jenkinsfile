@Library('gitcheck') _

pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "carlosdelgadillo/sumaa"
        DOCKER_TAG = "latest"
        DOCKERHUB_CREDENTIALS_ID = "docker-hub-credentials"
        DOCKERHUB_REPO = "carlosdelgadillo/sumaa"
    }
    stages {
        stage('Greeting') {
            steps {
                gitcheck('World') // Usando la función de saludo
            }
        }
        stage('Push image') {
            steps {
                pushDockerImage(DOCKERHUB_CREDENTIALS_ID, DOCKER_IMAGE, DOCKER_TAG, DOCKERHUB_REPO)
            }
        }
    }
}


/*
def app
pipeline {
    agent any//{ label 'linux-node' }
    environment {
        // Variables de entorno para Docker
        DOCKER_IMAGE = "carlosdelgadillo/sumaa"
        DOCKER_TAG = "latest"
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
        stage('Deploy') {
            /*when {
                expression { currentBuild.result != 'SUCCESS' }
            }
            steps {
                script {
                    // Intenta detener y eliminar cualquier contenedor usando el puerto 8085
                    sh '''
                    CONTAINER_ID=$(docker ps -q --filter "publish=8085")
                    if [ -n "$CONTAINER_ID" ]; then
                        echo "Deteniendo el contenedor que usa el puerto 8085..."
                        docker stop $CONTAINER_ID
                        docker rm $CONTAINER_ID
                    fi
                    echo "Desplegando nuevo contenedor..."
                    docker run -d -p 8085:8085 ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                    //sh "docker.stop ${DOCKER_IMAGE}"
                    //sh "docker.rmi ${DOCKER_IMAGE} -f"
                    //sh "docker run -d -p 8085:8085 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    //sh 'docker run -d -p 8001:8001 sumaa'
                    // sh 'docker run -d -p 8001:8001 carlosdelgadillo/sumaa'
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
        stage('Approval') {
            agent none  // Ejecutar en el controlador de Jenkins, no en un agente específico
            steps {
                input(message: 'Deploy to Stage', ok: 'Yes')
                script{
                    // Enviar un mensaje a Slack notificando que se requiere una aprobación
                    slackSend(channel: '#jenkins', color: '#FFFF00', message: "El build está esperando aprobación para el despliegue.")
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
                // Verifica si el servicio ya existe y, si no, expónlo
                sh '''
                    if ! kubectl -n suma get service suma-deployment --ignore-not-found > /dev/null 2>&1; then
                        echo "El servicio no existe, exponiéndolo ahora..."
                        kubectl -n suma expose deployment suma-deployment --type=NodePort --port=8085
                    else
                        echo "El servicio suma-deployment ya existe, no se necesita exponerlo nuevamente."
                    fi
                '''
                }
            }
        }
        
    }
    post {
        success {
            slackSend (color: '#00FF00', message: "Build exitoso: ${env.JOB_NAME} [${env.BUILD_NUMBER}] (<${env.BUILD_URL}|Open>)")
        }
        failure {
            slackSend (color: '#FF0000', message: "Build fallido: ${env.JOB_NAME} [${env.BUILD_NUMBER}] (<${env.BUILD_URL}|Open>)")
        }
    }

   
}
*/