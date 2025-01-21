pipeline {
    agent any
    environment {
        // Define environment variables
        IMAGE_NAME = 'cloudsihmar/dummy-pet'
        PORT_MAPPING = '9090:8080'
        dockerhub_cred = credentials("dockerhub-creds")
    }

    stages {
       // clean workspace
       stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        // cleaning ends here

        // Git Stage starts
        stage('checkout from git') {
            steps {
            
                
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/CloudSihmar/pet.git']])
            }
        }
       // Git stage ends
       
       
       
       // Static Code Analysis starts
       stage('Static code analysis') {
            environment {
               SCANNER_HOME = tool 'sonar-scanner'
             }
        steps {
          withSonarQubeEnv('sonarqube-server') {
         sh """${SCANNER_HOME}/bin/sonar-scanner \\
                -Dsonar.projectKey=govtech-pet \\
                -Dsonar.projectName=govtech-pet \\
                -Dsonar.projectVersion=${BUILD_NUMBER} \\
                -Dsonar.skipSSLVerification=true \\
                -Dsonar.sources=src/main/java \\
                -Dsonar.tests=src/test/java \\
                -Dsonar.exclusions='src/main/resources/**/*.java,src/test/**/*.java,src/pmd/**/*,**/*.properties'
            """
       }
     }
       }
      // Static Code Analysis


       // Quality Gate stage starts
       
       stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: true, credentialsId: 'sonarqube-creds' 
                }
            } 
        }
       
       // Quality Gate ends
       
       // Build starts here
       stage("maven build"){
           steps {
                script {
                    sh 'mvn clean package'
                }
            } 
        }   
       // Build ends here
       
       
       
       // Software composition analysis starts
       
       stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'Dependency-Check'
            }
        }
       //Software composition analysis ends
       
       // Build stage starts 
        stage('build') {
            steps {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
                        // Login to Docker Hub , username and password are stored in jenkins credentials with dockerhub as ID.
                        sh "docker login -u ${docker_username} -p ${docker_password}"

                        // Build and push Docker image
                        sh "docker build -t $IMAGE_NAME:${BUILD_NUMBER} -f Dockerfile.v3 ."
                        sh "docker push $IMAGE_NAME:${BUILD_NUMBER}"
                    }
                    }
                      }
        // build stage ends
        
        
        // Trivy scan starts
          stage("TRIVY-IMAGE-SCAN"){
            steps{
                sh "trivy image $IMAGE_NAME:${BUILD_NUMBER} --no-progress  --timeout 10m --severity HIGH,CRITICAL > trivyimagescan.txt" 
                 }
                   }
        // Trivy stage ends
        
        // Trivy scan starts
          stage("TRIVY-IMAGE-SCAN1"){
            steps{
                sh "trivy image  $IMAGE_NAME:$BUILD_NUMBER --output result.html --severity HIGH,CRITICAL" 
                 }
                   }
        // Trivy stage ends
        
        // Deployment-change starts
          stage("Deployment-Change"){
            steps{
                dir('deployment-dir') {
                git branch: 'main', url: 'https://github.com/CloudSihmar/pet-argocd-k8s.git'
                
                withCredentials([string(credentialsId: 'github-secret', variable: 'GIT_TOKEN')])  {
                 sh '''
        
                    git config --global user.email "cloudsihmar@gmail.com"
                    git config --global user.name "cloudsihmar"
                    git config --global user.password "${GIT_TOKEN}"
                    sed -i "s|image: cloudsihmar/dummy-pet:.*|image: cloudsihmar/dummy-pet:${BUILD_NUMBER}|" deployment.yaml
                    git add deployment.yaml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git remote set-url origin https://${GIT_TOKEN}@github.com/cloudsihmar/pet-argocd-k8s.git
                    git push origin main
                    ls -al
                '''
                 }
                }
                }
                }
                // Deployment-change ends
                
        
                
     }
 }
