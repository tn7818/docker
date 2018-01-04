Docker Container Auto Install UPAS 
OS: CentOS 6.7
OS Ext Function: tar passwd expect(For UPAS Install.sh) openssh-server 
JDK: Oracle Over JDK 1.7.* 64bit
UPAS Version: UPAS 7.0 Fix 3 
UPAS Install User: upas
UPAS Installed Path: /home/upas
UPAS Service Start/Stop: uboot/udown

OS UPAS User profile Added 
##########DOCKER#################
alias ctrun='docker run --privileged -ti -v /soft:/soft --hostname=CTOS73 -p59736:9736 1c30b5b2b9ce /bin/bash'

# Kill All Running Containers
alias dockerkill='docker kill $(docker ps -a -q)' 

# Delete Stoped Containers
alias dockercleanc='docker rm $(docker ps -a -q)' 

# Delete Containers with "none" tag
alias dockercleani='docker rmi $(docker images -q -f dangling=true)' 

# Delete All Containers stoped & "none" tag
alias dockerclean='dockercleanc || true && dockercleani'
