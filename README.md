# mongo-replicaset
### Description
This repo contains vagrant+ansible k8s cluster setup and an example of mongodb replicaset deployment.  
It uses two other projects:  
[MongoDB Community Kubernetes Operator](https://github.com/mongodb/mongodb-kubernetes-operator)  
[Kubernetes NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)  

### Environment
K8S is running in three virtual machine which are provisioned by a combination of Vagrant with Ansible.  
VMs run on CentOS7.  
In order to start the cluster run the following commands:
```shell
# Change directory to cluster
mongo-replicaset $ cd cluster
# Start vagrant provisioning
mongo-replicaset/cluster $ vagrant up
```
Once your cluster is running we suggest copying .kube/config from the controlplane node onto your local computer.

### Deployment
In order to deploy the MongoDB replicaset use:
```shell
mongo-replicaset $ make install
```
It will install needed CRDs and deploy both NFS Provisioner as well as MongoDB Replicaset.  
On top of that it deploys Mongo Express which is an interactive lightweight Web-Based Administrative Tool to effectively manage MongoDB Databases. It will be available outside the cluster at 192.168.56.10:30081.

### Scaling
At the current state of development MongoDB Community Kubernetes Operator is not particularly helpful when it comes to scaling the replicaset (to say the least).  
In order to do it you need to:
* Change 'members' attribute in the config/mongo/replicaset.yaml file
* Delete statefulset.apps/mongodb using kubectl
* Hope for the best