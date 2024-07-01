node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        app = docker.build("carlosdelgadillo/sumaa")
    }

    stage('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
        }
    }

    stage('Install Dependencies') {
        // Instalar dependencias desde requirements.txt
        sh 'pip install -r requirements.txt'
    }

    stage('Run Tests') {
        // Ejecutar pruebas con cobertura
        sh 'pytest --cov=pytest-report.xml --cov-report xml:coverage.xml'
    }

    stage('SonarQube Analysis') {
        def scannerHome = tool 'sonar-scanner'
        withSonarQubeEnv('SonarQube Server') {
            sh "${scannerHome}/bin/sonar-scanner"
        }
    }

    stage('Trigger ManifestUpdate') {
        echo "hola Omar"
    }
}

