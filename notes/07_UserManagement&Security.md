# User Management & Security

We can set up GitHub oauth using ArgoCD's Dex server. The configuration is trivial, and the documentation does a good job of explaining it. We will not cover this today.

ArgoCD also supports a number of OIDC providers. [More info here.](https://argoproj.github.io/argo-cd/operator-manual/user-management/)

This auth can then be tied to Project permissions.

For the sake of this workshop, we have not set up any security. It should go without saying that our setup _is by no means secure_. ArgoCD does provide security features, [more info here.](https://argoproj.github.io/argo-cd/operator-manual/security/)

Users can be set up and assigned to groups, these permissions can then be mapped to projects and applications, as well as certain actions within those applications.

Because we aren't setting up SSO today (e.g. GitHub), we won't be able to configure users. But know that it's there!

## AppProjects

So what can we use AppProjects for, why not just use the default AppProject?

Well, we can use different projects in order to control:

* RBAC
* limiting source repos
* limiting target clusters
* limiting objects

Let's have a look at the [default project](./Exploring_AppProjects/default_appproject.yaml). We can see that it is effectively configured as an "allow all" - this is what we've been using so far.

Now let's look at another project, which is [far more locked down](./Exploring_AppProjects/example_appproject.yaml). Go through comments in the example AppProject.
