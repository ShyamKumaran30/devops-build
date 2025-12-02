pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'shyam302000'
    IMAGE_NAME = "${DOCKERHUB_USER}/devops-build"
    DEV_TAG = "${IMAGE_NAME}:dev"
    PROD_TAG = "${IMAGE_NAME}:prod"
    REPO_URL = 'https://github.com/ShyamKumaran30/devops-build.git'
    EC2_USER = 'ubuntu'
    EC2_HOST = '54.242.241.204'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build image') {
      steps {
        sh "docker build -t ${DEV_TAG} ."
      }
    }

    stage('Push to Docker Hub (dev)') {
      when {
        branch 'dev'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker push ${DEV_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Push to Docker Hub (prod)') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker tag ${DEV_TAG} ${PROD_TAG}
            docker push ${PROD_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Deploy to EC2') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-key', keyFileVariable: 'EC2_KEYFILE')]) {
          sh '''
            chmod 600 ${EC2_KEYFILE}
            scp -o StrictHostKeyChecking=no -i ${EC2_KEYFILE} ./deploy.sh ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/deploy.sh
            ssh -o StrictHostKeyChecking=no -i ${EC2_KEYFILE} ${EC2_USER}@${EC2_HOST} 'cd /home/${EC2_USER} && chmod +x deploy.sh && ./deploy.sh'
          '''
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
