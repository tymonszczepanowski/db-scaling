# db-scaling
### Description
This repo contains vagrant+ansible k8s cluster setup and examples of db scaling.

### Cluster
In order to set up a cluster we follow Kubernetes [docs](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/).
#### Prerequisites
Steps for the controlplane are as follows:  
1. Set SELinux in permissive mode
2. Disable swap
3. Add Docker yum repo
5. Set up Kubernetes yum repo
6. Install packages: containerd, kubelet, kubeadm, kubectl
7. Configure container runtime (containerd)
