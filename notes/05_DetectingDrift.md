# Detecting Drift

Let's have a look at how to detect drift. With a GitOps system, we should only make changes via the source git repository.

Let's start with port-forwarding to Prometheus:

`kubectl port-forward svc/prometheus-server 8090:80 -n prometheus`

Now you can get to Prometheus at localhost:8090

Search for the following PromQL query:

`argocd_app_info{name="prometheus"}`

You'll see the `sync_status` value is `Synced`

Let's make a change to Prometheus directly in the cluster, by changing the alertmanager replica count to 3:

`kubectl edit -n prometheus deployment prometheus-alertmanager`

Look at the:

1) ArgoCD UI; we are now out of sync!
2) Look at the Prometheus metric we used earlier; we are now out of sync: `argocd_app_info{name="prometheus"}`

## Auto-Sync

What if we enable the auto-sync features on the Prometheus application?

Go to the Application configuration we added for Prometheus. Uncomment/update `spec.syncPolicy.automated.prune` and `spec.syncPolicy.automated.selfHeal` to `true` (at the bottom of the file), commit and push to your repo.

Now we can check the Prometheus Application info to see if the meta-app has synced.

> You may need to trigger a forced sync since we don't have a webhook configured.

You'll see the meta-app sync the Prometheus Application, which in turn will converge the actual state of Prometheus to our desired state - e.g. 1 replica for Alertmanager.

Now ArgoCD has kicked in its auto-sync feature, and made the state of the cluster converge to the desired state.

Look:

1) Application is green in the UI again
2) Prometheus metric is happy!
