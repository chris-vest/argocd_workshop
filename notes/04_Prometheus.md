# Deploying Prometheus

Now we will deploy Prometheus via a GitOps workflow, using ArgoCD which we have just deployed.

All we need to do is add an ArgoCD Application manifest to the directory which ArgoCD is being synced with, and we'll have an Prometheus deployment!

First let's take a look at the [Application manifest](.applications/03_prometheus/prometheus_application.yaml).

Now you're ready to apply it:

Now let's move the "meta application" to our directory which ArgoCD will be watching:

`cp -r .applications/03_prometheus applications/`

Add to git & push:

`git add applications/ && git commit -m "Add Prometheus" && git push`

> You may need to force a sync!
