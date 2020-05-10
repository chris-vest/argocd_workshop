# GitOps & ArgoCD

## What is GitOps

Coined by WeaveWorks in 2017, although people were doing it before then without the term GitOps.

1. Git is the single source of truth of a system
2. Git is the single place where we operate (create, change, destroy, etc.)
3. All changes are observable / verifiable

Clusters should be like cattle, not sheep - that means configuration as code; reliable, reproducible, verifiable

### What's declarative

Take Kubernetes, you give it some manifests and Kubernetes will continually try to drive the cluster to the state described in the declaration. Kubernetes uses control loops to make sure this state is maintained.

### Declarative systems & GitOps defined

[According to Weave](https://www.weave.works/blog/what-is-gitops-really):

1. Describe the desired state of the whole system using a declarative specification for each environment.  (In our story, Bob’s team owns the whole system config in Git.)
    * A git repo is the single source of truth for the desired state of the whole system.
    * All changes to the desired state are Git commits.
    * All specified properties of the cluster are also observable in the cluster, so that we can detect if the desired and observed states are the same (converged) or different (diverged).

2. When the desired and observed states are not the same then:
    * There is a convergence mechanism to bring the desired and observed states in sync both eventually, and autonomically.  Within the cluster, this is Kubernetes.
    * This is triggered immediately with a “change committed” alert.  
    * After a configurable interval, an alert “diff” may also be sent if the states are divergent.

3. Hence all Git commits cause verifiable and idempotent updates in the cluster.
    * Rollback is: “convergence to an earlier desired state”.

4. Convergence is eventual and indicated by:
    * No more “diff” alerts during a defined time interval.
    * A “converged” alert (eg. webhook, Git writeback event).

We will see that ArgoCD fulfills all of these definitions of GitOps.

### Enabling GitOps with tooling

[Flux by Weave](https://github.com/fluxcd/flux)

Later came [Faros by Pusher](https://github.com/pusher/faros) and [ArgoCD by the Argo team](https://github.com/argoproj/argo-cd)

...and many more, all with slightly different approaches.

## Benefits

### Security

In an ideal world, all changes to the system are done via Git, and at least 4 eyes have reviewed the change.

No users should be able to change a system directly, circumventing the GitOps process - they simply don't have access to do so!

### Automation

Developers do not necessarily know about Kubernetes, or want to know (it happens). As such it can be useful the abstract Kubernetes from the developer /  engineer. Having automated, declarative deployments can be useful for this. I.e., if an engineer's code has passed testing and all that good stuff, it can be automagically deployed via GitOps and he doesn't need to know anything else about the process. The system will converge to that state, given available resources.

### Configuration as code

Just as an application's source of truth is its code in a repo, our _entire system_ can be treated the same way.

If you have sensible settings for your Git repositories, all changes to your system must happen via pull requests; i.e. someone has to review it - less chance for something to go wrong, insecure things to happen, etc..

The other benefit of Git is that if _all_ changes happen in Git, we have an audit log of sorts, with zero effort at all! This is very useful for a number of reasons. Chiefly, all changes to the system being observable and verifiable.

### CI Servers Doing CD

Given we are working with a declarative system, CI servers do not provide much in the way of confirming a "deployment" has succeeded.

Take Jenkins as an example, we run a build, unit tests, e2e tests, then "deploy" it by shelling out to kubectl. Do we wait for the process to finish, then hack together a second script to make sure it has "deployed" succesfully? No, we shouldn't do this - that's the "old way"; we are in a declarative world now.

ArgoCD gives us the confidence that it will work with Kubernetes to converge toward the expected state.

## Drawbacks and how they're addressed

Drift! Git stores your source of truth, although you then still have the state of your system... The GitOps tool of choice will handle the diffing and convergence towards your desired state. Your monitoring tooling will handle alerting if your tool cannot converge to your desired state. Manual intervention may be required at this point.

Thus, drift solved using diffs and control loops; same principles of _automation_ and _convergence_ in Kubernetes! Again, we may reach a state where we cannot converge (configuration error, etc.) - at this point a cluster admin may need to intervene.

## Sources

* https://www.weave.works/blog/gitops-operations-by-pull-request
* https://www.weave.works/blog/what-is-gitops-really