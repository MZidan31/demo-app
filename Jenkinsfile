podTemplate(
  label: 'ci-with-docker',
  yaml: """
apiVersion: v1
kind: Pod
spec:
  initContainers:
  - name: fix-docker-perm
    image: busybox
    command: ['sh', '-c', 'addgroup -g 999 docker; adduser jenkins docker || true']
    volumeMounts:
      - name: dockersock
        mountPath: /var/run/docker.sock
  containers:
  - name: docker
    image: jenkins-agent-docker:latest
    command: ['cat']
    tty: true
    volumeMounts:
      - name: dockersock
        mountPath: /var/run/docker.sock
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
"""
) {
  node('ci-with-docker') {
    stage('Build') {
      container('docker') {
        sh '''
          docker version
          docker build -t mzidan/demo-app:${BUILD_ID} .
          minikube image load mzidan/demo-app:${BUILD_ID}
        '''
      }
    }
    // lanjut stage Push & Deploy...
  }
}
