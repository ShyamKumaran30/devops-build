 pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "shyam302000"
        IMAGE_NAME     = "devops-build"
        EC2_IP         = "54.242.241.204"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                sh """
                    docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:dev .
                """
            }
        }

        stage('Push to Docker Hub (dev)') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'USER',
                                                 passwordVariable: 'PASS')]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:dev
                    """
                }
            }
        }

        stage('Push to Docker Hub (prod)') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'USER',
                                                 passwordVariable: 'PASS')]) {
                    sh """
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker tag ${DOCKERHUB_USER}/${IMAGE_NAME}:dev ${DOCKERHUB_USER}/${IMAGE_NAME}:prod
                        docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:prod
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key',
                                                   keyFileVariable: 'EC2_KEYFILE')]) {

                    sh """
                        chmod 600 $EC2_KEYFILE

                        # Copy the deploy script
                        scp -o StrictHostKeyChecking=no -i $EC2_KEYFILE ./deploy.sh ubuntu@${EC2_IP}:/home/ubuntu/deploy.sh

                        # Run deploy script on EC2
                        ssh -o StrictHostKeyChecking=no -i $EC2_KEYFILE ubuntu@${EC2_IP} \
                        "cd /home/ubuntu && chmod +x deploy.sh && ./deploy.sh"
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}
