SHELL := /bin/bash

install-nfspv-rbac:
	kubectl create -f config/nfs-provisioner/rbac.yaml

install-nfspv-storage-class:
	kubectl create -f config/nfs-provisioner/storage-class.yaml

deploy-nfspv:
	kubectl create -f config/nfs-provisioner/provisioner.yaml

deploy-nfs-provisioner: install-nfspv-rbac install-nfspv-sc deploy-nfspv


install-mongo-crd:
	kubectl apply -f config/mongo-with-operator/crd.yaml

install-mongo-rbac:
	kubectl apply -k config/mongo-with-operator/rbac/ --namespace chmurki

deploy-mongo-operator: install-mongo-crd install-mongo-rbac
	kubectl create -f config/mongo-with-operator/manager.yaml --namespace chmurki

deploy-mongo-replicaset:
	kubectl create -f config/mongo-with-operator/replicaset.yaml --namespace chmurki

deploy-mongo: deploy-mongo-operator deploy-mongo-replicaset


print-nodes:
	kubectl get nodes -o wide && echo

print-chmurki:
	kubectl get all -n chmurki && echo

print-chmurki-pv:
	kubectl get pv -n chmurki && echo

print-chmurki-pvc:
	kubectl get pvc -n chmurki && echo

print: print-nodes print-chmurki print-chmurki-pv print-chmurki-pvc
