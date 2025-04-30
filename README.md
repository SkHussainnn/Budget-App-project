# DevOps Assessment

This assessment involves deploying a Ruby on Rail application with an Database Postgres SQL using Docker, Kubernetes, ArgoCD and TekTon. Follow the steps below to complete the tasks.

## Step 1: Docker
### Task
#### Build a Dockerfile for deploying a simple Ruby on Rails application with PostgreSQL DB  enabled. Application and DB should run on different containers.

### Steps
1. Create a new Rails application or use an existing one.
2. Write a Dockerfile to containerize the Rails application.
   ```Dockerfile
   FROM ruby:3.1.2

   RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
   RUN gem install bundler:2.3.6
   ENV BUNDLE_PATH /usr/local/bundle

   WORKDIR /app
   COPY Gemfile* ./
   RUN bundle install

   COPY . .
   RUN bundle exec rake assets:precompile
   EXPOSE 3000

   CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

3. Write a Dockerfile to run Postgres SQL in it
   ```Dockerfile-db
   FROM postgres:13

   ENV POSTGRES_USER=postgres
   ENV POSTGRES_PASSWORD=postgres
   ENV POSTGRES_DB=myapp_development

   EXPOSE 5432
5. Build Docker container for the Rails application and Postgress and push it on Docker-Hub
   
   ```docker build -t skhussain786/myrail-app:1.0 .```
   
<<<<<<< HEAD
   ```docker build -t skhussain786/mypostgres-sql-image:latest .```
   
   ```docker push skhussain786/myrail-app:1.0```
   
   ```docker push skhussain786/mypostgres-sql-image:latest```
=======
   ```docker build -t skhussain/mypostgres-sql-image:latest .```
   
   ```docker push skhussain786/myrail-app:1.0```
   
   ```docker push skhussain/mypostgres-sql-image:latest```
>>>>>>> 5e1150e (1)
   
7. You can Directly Access the Application by running the Docker Compose file.
   
   ```docker-compose up --build```
   
   ![image](https://github.com/SkHussainnn/Budget-App-project/assets/62510989/a10ce854-a17f-45d3-91b2-6419777d7f3a)


## Step 2: Kubernetes

### Task
#### Build a YAML file for the same application you’ve used in your first step to deploy it on Kubernetes. You can use any local cluster provider such as Minikube or K3d. The deployment of the standalone PostgreSQL pod must use Kubernetes StatefulSet. Additionally, the candidate may use any ingress controller they are comfortable with or a service mesh.

```bash
Kubectl apply -f manifests/service.yaml      
Kubectl apply -f manifests/postgres-statefulset.yaml
Kubectl apply -f manifests/rails-deployment.yaml
Kubectl apply -f Manifests/Ingress.yaml
```

## Step 3: ArgoCD
### Task
#### Deploy ArgoCD to manage the deployment of the previously mentioned application using GitOps. The candidate must create a private GitHub repository to manage the YAML files and for GitOps purposes. All ArgoCD config files must be present in the GitHub repository. The expected files include application.yaml to define the application to deploy, ArgoCD config maps (argocd-cm and argocd-rbac-cm), a config file for/(to add) the private GitHub repository and kubernetes manifest files.

ArgoCD can be installed using the following commands:

- To create a namespace "argocd", execute the following command. However, this step is optional and you can proceed with the "default" namespace as well:<br>
  `kubectl create namespace argocd`

- Run the install ArgoCD script by executing the following command: <br>
  `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

- Install the CLI using brew to use argocd commands: <br>
  `brew install argocd`

- To retrieve the password, execute the following command: <br>
  `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

- To access ArgoCD on a browser, forward the port to 8080 by executing the following command: <br>
 `kubectl port-forward svc/argocd-server -n argocd 8080:443`

- Deployment the YAML configuration
  - create `argocd` folder which will have our argo-cd configurations which are as follow:
     - argocd-cm.yaml
     - argocd-project.yaml
     - argocd-rbac-cm.yaml
     - repo-secret.yaml
  - Now create an `application.yaml` file which will start the argocd server and make the changes accordingly.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: rails-app
  namespace: argocd
spec:
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  source:
    path: manifests
    repoURL: https://github.com/SkHussainnn/Budget-App-project/my-argocd-repo.git
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
![image](https://github.com/SkHussainnn/Budget-App-project/assets/62510989/798a3163-28d9-482a-a184-ea3cfef6fd3f)

## Step 4: Tekton

### Task
Set up Tekton pipelines and the Tekton dashboard. The pipeline should download the source code from the public fork of the sample project (Which you’ve containerized in the first step), build the image, and push it to Docker Hub. The candidate is expected to manually run the pipeline from the Tekton dashboard.

### Steps
1. Install and configure Tekton on your Kubernetes cluster.
2. Create Tekton Tasks ([task.yaml](https://github.com/SkHussainnn/Budget-App-project/blob/main/manifests/tekton/task.yaml)) for building the application image.
3. Define a Tekton Pipeline ([build-pipeline.yaml](https://github.com/SkHussainnn/Budget-App-project/blob/main/manifests/tekton/pipeline.yaml)) that includes the Task.
4. Create a PipelineRun ([pipelineruns.yaml](https://github.com/SkHussainnn/Budget-App-project/blob/main/manifests/tekton/pipelineruns.yaml)) to trigger the pipeline.
5. Create a secret ([secret.yaml](https://github.com/SkHussainnn/Budget-App-project/blob/main/manifests/tekton/secret.yaml)) for accessing Docker.
6. Access the Tekton dashboard and manually run the pipeline.
7. Verify that the source code is downloaded, the image is built, and it is pushed to Docker Hub.

## Working

- Start with installing Tekton
```bash
kubectl apply --filename \
https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

- Apply the changes
```bash
kubectl apply -f manifests/application.yaml
kubectl apply -f task.yaml
kubectl apply -f sercret.yaml
kubectl apply -f pipeline.yaml
kubectl apply -f pipelineruns.yaml
```

- Run the Pipeline 
```bash
<<<<<<< HEAD
tkn pipeline start build-and-push-pipeline --param gitrepo=https://github.com/SajjanYadav/Budget-App.git --param context-dir="Ruby_on_rails" --param dockerfile="./Dockerfile" --param docker-image="https://hub.docker.com/r/sajjany/budget-app:latest"
```
=======
tkn pipeline start build-and-push-pipeline --param gitrepo=https://github.com/SkHussainnn/Budget-App-project.git--param context-dir="Ruby_on_rails" --param dockerfile="./Dockerfile" --param docker-image="https://hub.docker.com/r/skhussan786/myrail-app:1.0"
```
>>>>>>> 5e1150e (1)
