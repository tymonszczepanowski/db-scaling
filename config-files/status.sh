#!/bin/bash
kubectl get nodes -o wide
echo
kubectl get all -n chmurki
echo
kubectl get pv -n chmurki
echo
kubectl get pvc -n chmurki
