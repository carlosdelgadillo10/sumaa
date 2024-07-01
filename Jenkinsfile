node {
    def app
    def venv = 'venv' // Nombre del directorio del entorno virtual

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

    stage('Setup Virtual Environment') {
        // Crear el entorno virtual
        sh "python3 -m venv ${venv}"

        // Activar el entorno virtual y actualizar pip
        sh """
        . ${venv}/bin/activate
        pip install --upgrade pip
        """
    }

    stage('Install Dependencies') {
        // Activar el entorno virtual e instalar dependencias
        sh """
        . ${venv}/bin/activate
        pip install pytest pytest-cov
        """
    }

    stage('Run Tests') {
        // Activar el entorno virtual y ejecutar pruebas con cobertura
        sh """
        . ${venv}/bin/activate
        pytest --cov=suma --cov-report xml:coverage.xml
        """
    }

    stage('SonarQube Analysis') {
        def scannerHome = tool 'sonar-scanner'
        withSonarQubeEnv('SonarQube Server') {
            // Activar el entorno virtual y ejecutar el análisis de SonarQube
            sh """
            . ${venv}/bin/activate
            ${scannerHome}/bin/sonar-scanner
            """
        }
    }

    stage('Trigger ManifestUpdate') {
        echo "hola Omar"
    }
}
