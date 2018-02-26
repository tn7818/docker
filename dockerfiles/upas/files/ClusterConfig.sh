#!/bin/bash
echo "######Domain Config (Create New Domain && Add New Server to Domain )#######"
echo "######Cluster List(default) : /home/upas/binary/clusterList"
echo "######Cluster Name(default) : cls1"
echo "######Cluster Appended Member (Server Name ,default) : HostName"

clusterFile=/home/upas/binary/clusterList
clusterName=cls1
serverName=`hostname`

if [ -n "$1" ];then
clusterFile=$1
fi

if [ -n "$2" ];then
clusterName=$2
fi

if [ -n "$3" ];then
serverName=$3
fi

echo "#######Domain Cluster Pre Check Start#######"

echo -e "list-clusters \nquit"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD |awk ' NR > 9 && FS="|" {print substr($2,1,length($2))}' > $clusterFile

echo "#######Domain Cluster Pre Check End#########"

echo "####Create Domain Cluster Start#####"
if [ `grep -c $clusterName $clusterFile` -eq '0' ];then
echo -e "#Create Doamin Cluster $clusterName #\n"
echo -e "add-cluster $clusterName -servers $serverName \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD >> $clusterFile
echo -e "\n"
else
echo -e "#Domain Cluster $clusterName is Exist! #\n" >> $clusterFile
fi

echo "####Create Domain Cluster End######"

echo "#######Add Server to Cluster Pre Check Start#######"

echo -e "list-clusters $clusterName \nquit"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD |awk ' NR > 9 && FS="|" {print substr($2,1,length($2))}' > $clusterFile

echo "#######Add Server to Cluster Pre Check End#########"


echo "####Add New Server to Cluster Start####"

echo -e "Add $serverName to Cluster $clusterName #\n"
echo -e "add-servers-to-cluster $clusterName -servers $serverName \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD >> $clusterFile
echo -e "\n"

echo "####Add New Server to Cluster End######"
