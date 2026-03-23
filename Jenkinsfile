pipeline {
    agent any

    environment {
        DOCKER_USER = "surya8442"
        IMAGE_NAME = "instagram"
        IMAGE_TAG = "v1"
        CONTAINER_NAME = "myapp-container"
        APP_PORT = "3000"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Surya8442/twentyone.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Docker_cred',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker push $USER/myapp:v1
                    '''
                }
            }
        }

        stage('Run Container (Local Test)') {
            steps {
                sh '''
                    docker rm -f myapp-container || true
                    docker run -d --name myapp-container -p 3000:3000 surya8442/myapp:v1
                '''
            }
        }

        stage('Approval') {
            steps {
                input "Approve deployment to Kubernetes?"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config

                    kubectl get nodes

                    kubectl apply -f deployment.yml
                    kubectl apply -f Service.yml
                '''
            }
        }

        stage('Show App URL') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config

                    echo "======================================"
                    echo "Application deployed successfully 🚀"
                    echo "======================================"

                    kubectl get svc myapp-service
                '''
            }
        }
    }
}
