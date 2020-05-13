# Grafana, Metrics & Dashboards

So far we have been querying Prometheus directly for a single metric, but ArgoCD actually exposes a lot more metrics that are interesting for us to look at.

Let's deploy Grafana using the same method as before:

`cp -r .applications/04_grafana applications/`

Add to git & push:

`git add applications/ && git commit -m "Add Grafana" && git push`

> You may need to force a sync!

Once you see the Grafana application in ArgoCD, you can port-forward to it:

`kubectl port-forward -n prometheus svc/grafana 9090:80`

Go to Grafana at http://localhost:9090, you should have the ArgoCD dashboard there.

Let's explore it!

## Considering Alerts

We do not want to alert immediately when an Application's status is not In Sync, because most of the time these things will fix themselves.

If it's a real error, then it will not and you will want to alert on it.
