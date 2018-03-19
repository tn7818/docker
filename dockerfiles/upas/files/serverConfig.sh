#!/bin/bash
echo "######Server Config (Add New Server on the new Node && Start New Server )######"
echo "######Server Config Running Time(default) : 1 (1:Start 2:Stop)"
echo "######Server List(default) : /home/upas/binary/serverList"
echo "######Server Config Model(default) : server1"
echo "######Server New Name(default) : HostName"

serverFile=/home/upas/binary/serverList
targetServerName=server1
serverName=`hostname`
lifeFlag=1

if [ -n "$2" ];then
serverFile=$2
fi

if [ -n "$3" ];then
targetServerName=$3
fi

if [ -n "$4" ];then
serverName=$4
fi

if [ -n "$1" ];then
lifeFlag=$1
fi

function ServerPreCheck() {
echo "######Server Pre Check Start######"

echo -e "list-servers \nquit"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD > $serverFile
echo "######Server Pre Check End  ######"

}

function ServerDelete() {
echo "######Delete The Same Name Server Start######"

echo -e "#Remove $serverName #\n"
echo -e "remove-server $serverName \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD >> $serverFile
echo -e "\n"

echo "######Delete The Same Name Server End  ######"

}

function ServerAdd() {
echo "######Add New Server Start######"

LocalIP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
echo -e "Add $serverName - $LocalIP #\n"
echo -e "add-server $serverName -addr $LocalIP  -target $targetServerName -node `hostname` \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD >> $serverFile
echo -e "\n"

echo "######Add New Server End  ######"

}

case $lifeFlag in
1)
  ServerPreCheck
  ServerDelete
  ServerAdd ;;
2)
  ServerPreCheck
  ServerDelete ;;
*)
  echo "#Please Input LifeCycle Flag (1: Start 2: Stop)" ;;

esac
