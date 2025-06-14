podTemplate(
  label: 'ci-with-docker',
  containers: [
    containerTemplate(
      name: 'docker',
      image: 'jenkins-agent-docker:latest',
      command: 'cat', ttyEnabled: true
    )
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
  ]
) {
  node('ci-with-docker') {
    stage('Build') {
      container('docker') {
        sh 'docker version'
        sh 'docker build -t mzidan/demo-app:${BUILD_ID} .'
        sh 'minikube image load mzidan/demo-app:${BUILD_ID}'
      }
    }
    // Stage push dan deploy dst...
  }
}
