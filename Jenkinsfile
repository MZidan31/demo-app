podTemplate(
  label: 'docker-agent-full',
  containers: [
    containerTemplate(
      name: 'docker',
      image: 'jenkins-agent-docker:latest',
      command: 'cat', ttyEnabled: true,
      volumeMounts: [
        hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
      ]
    )
  ],
  volumes: [
    hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
  ]
) {
  node('docker-agent-full') {
    stage('Checkout') {
      checkout scm
    }
    stage('Build & Load Image') {
      container('docker') {
        sh '''
          docker build -t mzidan/demo-app:${BUILD_ID} .
          minikube image load mzidan/demo-app:${BUILD_ID}
        '''
      }
    }
    stage('Push to DockerHub') {
      container('docker') {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh 'docker push mzidan/demo-app:${BUILD_ID}'
        }
      }
    }
    stage('Helm Deploy') {
      container('docker') {
        withCredentials([file(credentialsId: 'kubeconfig-minikube', variable: 'KUBECONFIG')]) {
          sh '''
            helm upgrade --install demo-app helm-chart \
              --namespace demo --create-namespace \
              --set image.repository=mzidan/demo-app \
              --set image.tag=${BUILD_ID} \
              --set service.nodePort=30080
          '''
        }
      }
    }
  }
}
