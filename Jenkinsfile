pipeline {
  agent any

  environment {
    LOCAL_IMAGE    = "devops-lab"
    IMAGE_TAG      = "build-${BUILD_NUMBER}"
    DOCKERHUB_REPO = "araheman/devops-production-lab"
  }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  stages {

    stage('System Info') {
      steps {
        sh 'whoami'
        sh 'docker --version'
        sh 'git --version'
      }
    }

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/A-Raheman/devops-production-lab.git'
      }
    }

    stage('Build Image') {
      steps {
        sh 'ls -la'
        sh "docker build -t ${LOCAL_IMAGE}:${IMAGE_TAG} ."
      }
    }

    stage('Login & Push') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh """
            echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin

            # Push versioned tag (traceable)
            docker tag ${LOCAL_IMAGE}:${IMAGE_TAG} ${DOCKERHUB_REPO}:${IMAGE_TAG}
            docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}

            # Push latest tag (deployment-friendly)
            docker tag ${LOCAL_IMAGE}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
            docker push ${DOCKERHUB_REPO}:latest
          """
        }
      }
    }
    
    stage('Deploy to EC2') {
      steps {
	// Use an SSH private key stored as a Jenkins credential (recommneded)
	sshagent(credentials: ['ec2-ssh-key'] {
	sh """
	  ssh -o StrictHostKeyChecking=no ubuntu@3.111.34.40 '
	    set -e

	    echo "Pulling  latest image..."
	    docker pull ${DOCKERHUB_REPO}:latest

	    echo "Stopping old container (if any)..."
	    docker rm -f prodlab || true

	    echo "Starting new container..."
	    docker run -d --name prodlab --restart unless-stopped -p 80:80 ${DOCKERHUB_REPO}:latest

	    echo "Deployment complete. Running containers:"
	    docker ps --format "table {{.Names}}\\t{.Image}}\\t{{.Status}}\\t{{.Ports}}"
	  '
	 """
	}
      }
    }


    stage('Cleanup Local Images') {
      steps {
        sh """
          docker logout || true

          # Remove local tags created during the build (ignore failures)
          docker rmi ${LOCAL_IMAGE}:${IMAGE_TAG} || true
          docker rmi ${DOCKERHUB_REPO}:${IMAGE_TAG} || true
          docker rmi ${DOCKERHUB_REPO}:latest || true

          # Optional: prune dangling layers/cache (safe)
          docker system prune -f || true
        """
      }
    }
  }

  post {
    success {
      echo "Pushed: ${DOCKERHUB_REPO}:${IMAGE_TAG} and :latest"
    }
    always {
      echo "Pipeline finished."
    }
  }
}
