# All commands

## 01 Setup

```bash
./scripts/setup.sh
```

## 02 ArgoCD

Go to http://localhost - this is the ArgoCD UI

If that doesn't work, use the following command:

`kubectl port-forward svc/argocd-server 8080:80`

...and visit http://localhost:8080

Either way, credentials are as follows:

Username: `admin`
Password: `password`

### ArgoCD deploying itself

Apply ArgoCD Application file:

`kubectl apply -f applications/02_argocd/argocd_application.yaml`

Open it up and have a look at it while we discuss it.

### ArgoCD configuration file

Let's look at the main ArgoCD configuration file:

`kubectl get configmap -n default argocd-cm -o yaml`

## 03 App of Apps

Open up the [meta-application](../applications/02_meta/meta_application.yaml) and update line 15 with _your own repo URL_ (if you haven't done so already). I.e. the URL to your forked repository.

Now apply the meta-app Application:

`kubectl apply -f applications/02_meta/meta_application.yaml`

ArgoCD is now "watching" the `application` directory of your repository!

## 04 Prometheus

First let's take a look at the [Application manifest](../.applications/03_prometheus/prometheus_application.yaml).

Now let's move the "meta application" to our directory which ArgoCD will be watching:

`cp -r .applications/03_prometheus applications/`

Add to git & push:

`git add applications/ && git commit -m "Add Prometheus" && git push`

## 05 Detecting Drift

Let's start with port-forwarding to Prometheus:

`kubectl port-forward svc/prometheus-server 8090:80 -n prometheus`

Now you can get to Prometheus at localhost:8090

Search for the following PromQL query:

`argocd_app_info{name="prometheus"}`

### Forcing Drift

Let's make a change to Prometheus directly in the cluster, by changing the alertmanager replica count to 3:

Either:

`kubectl scale -n prometheus --replicas=3 deployment prometheus-alertmanager`

...or:

`kubectl edit -n prometheus deployment prometheus-alertmanager`

The Prometheus Application is now out of sync.

### Auto-sync

Go to the [Application configuration we added for Prometheus](../.applications/03_prometheus/prometheus_application.yaml). Uncomment and update `spec.syncPolicy.automated.prune` and `spec.syncPolicy.automated.selfHeal` to `true` (at the bottom of the file), commit and push to your repo.

`git add applications/ && git commit -m "Update Prometheus Application" && git push`

## 06 Grafana

Let's deploy Grafana using the same method as before:

`cp -r .applications/04_grafana applications/`

Add to git & push:

`git add applications/ && git commit -m "Add Grafana" && git push`

Once you see the Grafana application in ArgoCD, you can port-forward to it:

`kubectl port-forward -n prometheus svc/grafana 9090:80`

Go to Grafana at http://localhost:9090, you should have the ArgoCD dashboard there.

## 07 Security & AppProjects

Let's have a look at the [default project](./Exploring_AppProjects/default_appproject.yaml).

Now let's look at another project, which is [far more locked down](./Exploring_AppProjects/example_appproject.yaml).

## 08 Jenkins

Have a look at the [manifest for our AppProject](../.applications/05_jenkins/01_helm_stable_only.yaml).

### Unstable

Add the AppProject and our example Jenkins Application to where ArgoCD can see it & commit & push it:

`mkdir applications/05_jenkins && cp .applications/05_jenkins/01_helm_stable_only.yaml applications/05_jenkins/helm_stable_only_project.yaml && cp .applications/05_jenkins/02_Jenkins.yaml applications/05_jenkins/jenkins_application.yaml`

Add to git & push:

`git add applications/ && git commit -m "Add Jenkins" && git push`

### Stable

Now if we deploy Jenkins via the stable repo, let's see what happens.

`cp -f .applications/05_jenkins/03_Jenkins.yaml applications/05_jenkins/jenkins_application.yaml`

Add the Application to where ArgoCD can see it & commit & push it:

`git add applications/ && git commit -m "Update Jenkins" && git push`
