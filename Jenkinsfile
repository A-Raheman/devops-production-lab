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

         script {
           def BUILD_DATE = sh(script: "date -u --iso-8601=seconds", returnStdout: true).trim()

           sh """
            docker build \
            --build-arg BUILD_NUMBER=${env.BUILD_NUMBER} \
            --build-arg GIT_COMMIT=${env.GIT_COMMIT} \
            --build-arg BUILD_DATE=${BUILD_DATE} \
            -t ${LOCAL_IMAGE}:${IMAGE_TAG} .
           """
         }
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
	script {
	 env.PREV_TAG = "build-${env.BUILD_NUMBER.toInteger() - 1}"
	}

	withCredentials([sshUserPrivateKey(
	  credentialsId: 'ec2-ssh-key',
	  keyFileVariable: 'SSH_KEY',
	  usernameVariable: 'SSH_USER'
        )]) {
	  sh """
	    ssh -o StrictHostKeyChecking=no -i "\$SSH_KEY" "\$SSH_USER"@35.154.118.179 '
	      set -e
		     
	      echo "Deploying current version: ${IMAGE_TAG}"
	      echo "Rollback version if needed: ${env.PREV_TAG}"

	      echo "Pulling current image..."
	      docker pull ${DOCKERHUB_REPO}:${IMAGE_TAG}
	      
	      echo "Removing old candidate container if present..."
	      docker rm -f prodlab_candidate || true

	      echo "Starting candidate container on port 8081..."
	      docker run -d --name prodlab_candidate -p 8081:80 ${DOCKERHUB_REPO}:${IMAGE_TAG}

	      echo "Waiting for candidate to come up..."
	      sleep 5

	      echo "Running health check on candidate..."
	      if curl -fsS http://localhost:8081/version.html >/dev/null; then
		echo "Candidate is healthy. Replacing production container..."

		docker rm -f prodlab || true

		docker run -d --name prodlab --restart unless-stopped -p 80:80 ${DOCKERHUB_REPO}:${IMAGE_TAG}

		echo "Cleaning up candidate container..."
		docker rm -f prodlab_candidate || true
		
		echo "Deployment complete. Running container:"
		docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"
	      
	      else
		echo "Health check failed. Rolling back to previous version: ${env.PREV_TAG}"
		docker logs prodlab_candidate || true
		docker rm -f prodlab_candidate || true

		docker pull ${DOCKERHUB_REPO}:${env.PREV_TAG} || true
		docker rm -f prodlab || true
		docker run -d --name prodlab --restart unless-stopped -p 80:80 ${DOCKERHUB_REPO}:${env.PREV_TAG}

		echo "Rollback complete. Production restored to ${env.PREV_TAG}"
		docker ps --format "table {{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.Ports}}"

		exit 1
	      fi
	  
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
