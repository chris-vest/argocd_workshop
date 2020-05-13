# Exploring AppProjects with Jenkins

Now that we've discussed the possibilities of AppProjects a little bit, let's explore an example.

Have a look at the [manifest for our AppProject](../.applications/05_jenkins/01_helm_stable_only.yaml), we are limiting the source repo to the Helm Stable repository. Let's try to deploy something which is not from the Helm Stable source.

Add the AppProject and our example Jenkins Application to where ArgoCD can see it & commit & push it:

`mkdir applications/05_jenkins && cp .applications/05_jenkins/01_helm_stable_only.yaml applications/05_jenkins/helm_stable_only_project.yaml && cp .applications/05_jenkins/02_Jenkins.yaml applications/05_jenkins/jenkins_application.yaml`

Add to git & push:

`git add applications/ && git commit -m "Add Jenkins" && git push`

Go look at the Argo UI for the Jenkins Application. You will see that ArgoCD is not happy because the incubator repo is not in the allowed repos of our new project!

The same would happen if we tried to deploy to another namespace than what we have whitelisted.

Now if we deploy Jenkins via the stable repo, let's see what happens.

`cp -f .applications/05_jenkins/03_Jenkins.yaml applications/05_jenkins/jenkins_application.yaml`

Add the Application to where ArgoCD can see it & commit & push it:

`git add applications/ && git commit -m "Update Jenkins" && git push`

We can see this is created successfully! Hopefully you can see the power of these features.

## Using AppProjects

Projects can be useful for separating Applications into logical groupings.

For example, "platform" applications like we started deploying; Prometheus, Grafana; as well as other things metrics server, CNI, service mesh.

Another approach could be for security reasons. Taking the example of an AppProject for "platform" applications, perhaps we only want such applications to be sourced from a private company-owned GitHub repo. Perhaps we only want certain ArgoCD "groups" to be able to access it, no one else can even see it.

Again, if you give your engineers free reign to create ArgoCD Applications themselves, you may want them to limit the types of resources they're creating - i.e. no crazy ClusterRoles.
