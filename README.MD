# Docker Container Auto Install UPAS 

OS: CentOS 6.7

OS Ext Function: tar passwd expect(For UPAS Install.sh) openssh-server 

JDK: Oracle Over JDK 1.7.* 64bit

UPAS Version: UPAS 7.0 Fix 3 

UPAS Install User: upas

UPAS Installed Path: /home/upas

UPAS Service Start/Stop: uboot/udown



# #########DOCKER Profile Alias Setting##############
# Kill All Running Containers
alias dockerkill='docker kill $(docker ps -a -q)'
 
# Delete Stoped Containers
alias dockercleanc='docker rm $(docker ps -a -q)'
 
# Delete Containers with "none" tag
alias dockercleani='docker rmi $(docker images -q -f dangling=true)'
 
# Delete All Containers stoped & "none" tag
alias dockerclean='dockercleanc || true && dockercleani'



# ###########K8S_Config For UPAS7.0 Fix3#############
# Create UPAS7.0Fix3 Images
docker build -t registry.clstest.com:5000/library/iop/upas/das:1.0 -f ./dockerfiles/upas/Dockerfile.das
docker build -t registry.clstest.com:5000/library/iop/upas/ms:1.0 -f ./dockerfiles/upas/Dockerfile.ms

# Create UPAS7.0Fix3 Volumes Images(NFS)
docker build -t registry.clstest.com:5000/library/iop/upas/nfs:1.0 -f ./dockerfiles/nfs/Dockerfile.nfs

# Create UPAS7.0Fix3 Volumes Service
kubectl create -f ./nfs/nfs-server-svc.yaml

# Create UPAS7.0Fix3 Volumens Deploy
kubectl create -f ./nfs/nfs-server-deploy.yaml

# Create UPAS7.0Fix3 Persistent Volumens
kubectl create -f ./nfs/nfs-pv.yaml

# Create UPAS7.0Fix3 Persistent Volumens Claims
kubectl create -f ./nfs/nfs-pvc.yaml

# Create UPAS7.0Fix3 ConfigMap(UPAS User Profile : linuxprofile)
kubectl create configmap linuxprofile --from-file=das=./configMap/dasLinuxProfile --from-file=ms=./configMap/msLinuxProfile

# Create UPAS7.0Fix3 Service
kubectl create -f ./upas_das_svc.yaml
kubectl create -f ./upas_ms_svc.yaml

# Create UPAS7.0Fix3 Deploy
kubectl create -f ./upas_das_deploy.yaml
kubectl create -f ./upas_das_deploy.yaml

