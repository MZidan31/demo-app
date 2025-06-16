pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'masjidan/demo-app:latest'
    DOCKER_CREDENTIALS_ID = 'dockerhub-cred'
  }

  stages {
    stage('Checkout') {
      steps {
        git 'https://github.com/MZidan31/demo-app.git' // Ganti jika beda repo
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DOCKER_IMAGE .'
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS_ID", usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh '''
            echo $PASSWORD | docker login -u $USERNAME --password-stdin
            docker push $DOCKER_IMAGE
          '''
        }
      }
    }

    stage('Deploy to Kubernetes with Helm') {
      steps {
        sh '''
          helm upgrade --install demo-app ./helm-chart --namespace default --create-namespace
        '''
      }
    }
  }
}
