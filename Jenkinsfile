pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube'                  // Name configured in Jenkins system settings
        SONAR_TOKEN = credentials('sonar-token')        // Jenkins credentials ID
        DOCKER_IMAGE = 'static-web-app-image'
        PROJECT_TITLE = 'Integrating automated security scanning into DevOps pipelines with SonarQube and Trivy'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/your-username/your-repo.git' // REPLACE with your repo URL
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=StaticWebAppSecurityScan \
                          -Dsonar.projectName="$PROJECT_TITLE" \
                          -Dsonar.sources=. \
                          -Dsonar.sourceEncoding=UTF-8 \
                          -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh '''
                    if ! command -v trivy &> /dev/null; then
                        echo "Installing Trivy..."
                        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
                    fi

                    ./trivy image --exit-code 1 --severity CRITICAL,HIGH ${DOCKER_IMAGE}
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f static-web-container || true
                    docker run -d -p 8080:80 --name static-web-container ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        success {
            echo '🎉 Deployment Successful!'
            echo 'Visit http://<your-server-ip>:8080 to view the static web app.'
        }
        failure {
            echo '🚨 Deployment Failed. Check logs above.'
        }
    }
}
