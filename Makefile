SHELL := /bin/bash

create-namespace:
	kubectl create namespace chmurki

# nfs-provisioner
install-nfspv-rbac:
	kubectl create -f config/nfs-provisioner/rbac.yaml

install-nfspv-sc:
	kubectl create -f config/nfs-provisioner/storage-class.yaml

deploy-nfspv:
	kubectl create -f config/nfs-provisioner/provisioner.yaml

deploy-nfs-provisioner: install-nfspv-rbac install-nfspv-sc deploy-nfspv


# mongo
install-mongo-crd:
	kubectl apply -f config/mongo/crd.yaml

install-mongo-rbac:
	kubectl apply -k config/mongo/rbac/ --namespace chmurki

deploy-mongo-operator: install-mongo-crd install-mongo-rbac
	kubectl create -f config/mongo/manager.yaml --namespace chmurki

deploy-mongo-replicaset:
	kubectl create -f config/mongo/replicaset.yaml --namespace chmurki

deploy-mongo: install-mongo-crd install mongo-rbac deploy-mongo-operator deploy-mongo-replicaset


# mongo-express
deploy-express:
	kubectl apply -f config/express/deploy.yaml


# prints
print-nodes:
	kubectl get nodes -o wide && echo

print-chmurki:
	kubectl get all -n chmurki && echo

print-chmurki-pv:
	kubectl get pv -n chmurki && echo

print-chmurki-pvc:
	kubectl get pvc -n chmurki && echo

print: print-nodes print-chmurki print-chmurki-pv print-chmurki-pvc

install: create-namespace deploy-nfs-provisioner deploy-mongo deploy-express
