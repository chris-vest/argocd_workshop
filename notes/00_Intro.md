# Intro

In this workshop we're going to describe the whole state of the system in Git. We will do some manual changes to start with, but we will see how we can manage the system using only Git commits; we will see how you could shut down permissions in ArgoCD to only allow changes via Git commits; as well as how to detect drift and allow the system to self-heal via ArgoCD auto-syncing.

We will see what a system which has the property of eventual consistency: our changes may not happen immediately every time, because we're relying on control loops. But the system will attempt to converge to its desired state, given we have enough resources & no errors in configuration.

We'll do all of this by deploying ArgoCD, Prometheus, Grafana and a Jenkins instance.
