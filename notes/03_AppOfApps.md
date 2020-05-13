# App of Apps

Okay, we've been deploying applications directly to the cluster using manifests. But that's not GitOps... How do we make ArgoCD aware of our applications repo? We can use a meta-app.

Firstly, open up the [meta-application](.applications/02_meta/meta_application.yaml) - this is the Application manifest for the app of apps. It will be responsible for syncing all of our manifests to ArgoCD from our git repo. Have a skim through it.

!!!Make sure to update line 15 with your own repo URL!!!

Now let's move the "meta application" to our directory which ArgoCD will be watching:

`cp -r .applications/02_meta applications/`

Add to git & push:

`git add applications/ && git commit -m "Add meta-app" && git push`

This pattern of git commands above you will be needing later too, whenever we add something for ArgoCD to handle.

Make sure:

1) you updated the meta-application to use your forked repo!
2) your forked repo is public!

## Webhooks

Usually at this point you should also [set up a webhook](https://argoproj.github.io/argo-cd/operator-manual/webhook/) such that ArgoCD is notified immediately of pushes to your source repository. For this workshop, we won't be doing that.

## Supporting Documentation

App of apps pattern for cluster bootstrapping[meta-application](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/#app-of-apps-pattern)
