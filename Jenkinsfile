node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Install dependencies') {
        // Instalación de dependencias en un entorno virtual
        sh 'python3 -m venv venv'
        sh './venv/bin/pip install -r requirements.txt'
    }

    stage('Build image') {
        app = docker.build("carlosdelgadillo/sumaa")
    }

    stage('Test and coverage') {
        // Ejecutar pytest con cobertura
        sh '''
            . venv/bin/activate
            export PYTHONPATH=$PWD
            pytest --cov=app --cov-report=xml:coverage.xml --cov-report=term-missing
        '''
    }

    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
        }
    }

    stage('SonarQube Analysis') {
        def scannerHome = tool 'sonar-scanner';
        withSonarQubeEnv('server-sonar') {
            sh """
                ${scannerHome}/bin/sonar-scanner \
                -Dsonar.projectKey=suma-fastapi \
                -Dsonar.sources=app/ \
                -Dsonar.tests=tests/ \
                -Dsonar.python.coverage.reportPaths=coverage.xml \
                -Dsonar.projectVersion=${env.BUILD_NUMBER} \
                -Dsonar.sourceEncoding=UTF-8
            """
        }
    }
    
    stage('Trigger ManifestUpdate') {
        echo "hola erdnando"
    }
}
