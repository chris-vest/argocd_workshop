# Explore ArgoCD UI & Configuration

You can reach ArgoCD at https://localhost, depending on your browser you may need to accept the security warning and continue to the UI from there.

If this does not work, no matter, we can port foward to ArgoCD and reach it on http://localhost:8080 -

`kubectl port-forward svc/argocd-server 8080:80`

> Take a quick trip around the UI using username `admin` and password `password`

Let's have a look at the [architectural overview](https://argoproj.github.io/argo-cd/operator-manual/architecture/)

Three components:

### API server
The API server is a gRPC/REST server which exposes the API consumed by the Web UI, CLI, and CI/CD systems. It has the following responsibilities:

* application management and status reporting
* invoking of application operations (e.g. sync, rollback, user-defined actions)
* repository and cluster credential management (stored as K8s secrets)
* authentication and auth delegation to external identity providers
* RBAC enforcement
* listener/forwarder for Git webhook events

### Repository Server

The repository server is an internal service which maintains a local cache of the Git repository holding the application manifests.

Responsible for generating and returning the Kubernetes manifests.

### Application Controller

The application controller is a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the repo).

It detects OutOfSync application state and optionally takes corrective action.

Responsible for invoking any user-defined hooks for lifecycle events (PreSync, Sync, PostSync)

## ArgoCD deploying itself

Deploy the ArgoCD Application:

`kubectl apply -f applications/01_argocd/argocd_application.yaml`

Now ArgoCD is syncing itself!

> Go to the UI, explore what ArgoCD shows in the Application UI for the meta-app.

Have a look at the file we applied so we can discuss it.

Let's look at the main ArgoCD configuration file:

`kubectl get configmap -n default argocd-cm -o yaml`

This is the configmap for configuration!

--> Project - logical grouping of applications: we'll explore this more later

--> Application - look through the ArgoCD Application as an example

## CLI

There is also an ArgoCD CLI, however since we are in the GitOps realm, we want all of our configuration to be done via the configuration files / Helm chart. More on that in the next section...
