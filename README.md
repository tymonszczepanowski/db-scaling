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
![Screenshot](screenshots/env.png)

### Deployment
In order to deploy the MongoDB replicaset use:
```shell
mongo-replicaset $ make install
```
It will install needed CRDs and deploy both NFS Provisioner as well as MongoDB Replicaset.  
On top of that it deploys Mongo Express which is an interactive lightweight Web-Based Administrative Tool to effectively manage MongoDB Databases. It will be available outside the cluster at 192.168.56.10:30081.
![Screenshot](screenshots/arch.png)

### Scaling
In order to scale the mongo replicaset, you need to:
* Change 'members' attribute in the config/mongo/replicaset.yaml file
* Run kubectl apply -f config/mongo/replicaset -n chmurki
* Hope for the best

### Exposing mongodb-svc
For some weird reason operator has a problem with defining a NodePort service inside the config/mongo/replicaset.yaml.  
Therefore, in order to expose database's service we simply use kubectl port-forward:
```shell
$ kubectl port-forward service/mongodb-svc 27017:27017 -n chmurki
```

### Testing
For testing we have used [Yahoo! Cloud Serving Benchmark](https://github.com/brianfrankcooper/YCSB)  
```shell
$ curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.17.0/ycsb-0.17.0.tar.gz
$ tar xfvz ycsb-0.17.0.tar.gz
$ cd ycsb-0.17.0
# Load data
ycsb-0-17.0 $ ./bin/ycsb load mongodb -s -P workloads/workloada -p recordcount=100000 -threads 4 -p mongodb.url="mongodb://user:password@localhost:27017/admin"
# Run benchmark
ycsb-0-17-0 $ ./bin/ycsb run mongodb -s -P workloads/workloada -threads 2 -p mongodb.url="mongodb://user:password@localhost:27017/admin"
```