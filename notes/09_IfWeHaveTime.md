# ArgoCD Features

## Managing namespaces

We have been using Helm charts, and most community Helm charts do not create the namespaces which they by default target, e.g. Prometheus Helm chart --> prometheus namespace

This is why we created the prometheus & grafana namespaces inside of the `deployArgoCD.sh` script.

As such, a good pattern is to have a namespace Application which simply creates all namespaces upon bootstrapping a new cluster.

## Finalizers

ArgoCD has a great way of handling deletion in a GitOps system. Using an annotation on your Application resource:

```yaml
metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io
```

This will cause ArgoCD to delete the Application's resources when the Application is removed.

## Supporting multiple tools

Today we have only used Helm, but ArgoCD can also support raw Kubernetes manifests in both JSON and YAML, Kustomize, Jsonnet and Ksonnet. If you want to use some other tool you can add it to ArgoCD youself as a plugin!

## Resource hooks

During a Sync operation, Argo CD will apply the resource during the appropriate phase of the deployment. Hooks can be any type of Kubernetes resource kind, but tend to be Pod, Job or Argo Workflows.

Multiple hooks can be specified as a comma separated list.

| Hook        | Description |
| ------------| ----------:|
| PreSync | Executes prior to the apply of the manifests.
| Sync | Executes after all PreSync hooks completed and were successful, at the same time as the apply of the manifests.
| Skip | Indicates to Argo CD to skip the apply of the manifest.
| PostSync | Executes after all Sync hooks completed and were successful, a successful apply, and all resources in a Healthy state.
| SyncFail | Executes when the sync operation fails.

## Waves

Using an ArgoCD feature called Waves, we can control the order in which objects are deployed. If the resource in a previous wave is not healthy, then ArgoCD will not continue.

This can be useful for a number of reasons... A concrete example could be database migrations before an application deployment.

## Multi-tenancy

We can configure ArgoCD to deploy not only to the cluster it's deployed in, but also to other clusters! This is a kind of multi-tenancy, which is a very neat feature of ArgoCD.

For today we have only used the local `kind` cluster.

## Suggestions for you to look at in your own time

[Argo Workflows](https://github.com/argoproj/argo) and Argo Events - provides very nice "Kubernetes native" approaches to Workflows, e.g. running tests, CI, DAGs, etc.. Anything you can dream of.
