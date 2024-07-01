node {
    def app
    def venvDir = 'venv' // Nombre del directorio del entorno virtual

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
        sh "python3 -m venv ${venvDir}"

        // Activar el entorno virtual y actualizar pip (forzando la actualización)
        sh """
        . ${venvDir}/bin/activate
        pip install --upgrade pip --break-system-packages
        """
    }

    stage('Install Dependencies') {
        // Activar el entorno virtual e instalar dependencias (forzando la instalación)
        sh """
        . ${venvDir}/bin/activate
        pip install pytest pytest-cov --break-system-packages
        """
    }

    stage('Run Tests') {
        // Activar el entorno virtual y ejecutar pruebas con cobertura
        sh """
        . ${venvDir}/bin/activate
        pytest --cov=pytest-report.xml --cov-report xml:coverage.xml
        """
    }

    stage('SonarQube Analysis') {
        def scannerHome = tool 'sonar-scanner'
        withSonarQubeEnv('SonarQube Server') {
            // Activar el entorno virtual y ejecutar el análisis de SonarQube
            sh """
            . ${venvDir}/bin/activate
            ${scannerHome}/bin/sonar-scanner
            """
        }
    }

    stage('Trigger ManifestUpdate') {
        echo "hola Omar"
    }
}
