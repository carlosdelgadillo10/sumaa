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

        // Activar el entorno virtual e instalar dependencias desde requirements.txt
        sh """
        . ${venvDir}/bin/activate
        pip install --upgrade pip --break-system-packages
        pip install -r requirements.txt --break-system-packages
        """
    }

    stage('Run Tests') {
        // Asegurarse de estar en el directorio correcto antes de ejecutar las pruebas
        sh """
        . ${venvDir}/bin/activate
        pytest --cov=suma --cov-report xml:coverage.xml
        """
    }

    stage('SonarQube Analysis') {
        def scannerHome = tool 'sonar-scanner'
        withSonarQubeEnv('server-sonar') {
            // Ejecutar el análisis de SonarQube
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
