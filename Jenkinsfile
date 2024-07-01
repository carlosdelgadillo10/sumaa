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

    stage('Run Tests') {
        // Instalar dependencias necesarias
        sh 'pip install pytest pytest-cov'

        // Ejecutar pruebas con cobertura
        sh 'pytest --cov=suma --cov-report xml:coverage.xml'
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
