#!/bin/bash
echo "######Node Check (N-Ready Node Delete && Ready Node Register)######"
echo "######Node Check Running Time(default) : 1 (1:Start 2:Stop)"
echo "######Node Check List(default) : /home/upas/binary/nodeLost"

nodeFile=/home/upas/binary/nodeLost
lifeFlag=1;

if [ -n "$2" ];then
nodeFile=$2
fi

if [ -n "$1" ];then
lifeFlag=$1
fi

function NodePreCheck() {
echo "######Node Pre Check Start######"

echo -e "nodelist \nquit"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD|awk 'NR>8 && $6=="N" {print $2}' > $nodeFile
echo "######Node Pre Check End  ######"

}

function NodeDelete() {
echo "######N-Ready Node Delete Start######"

for i in  `cat $nodeFile`
do
echo -e "#Remove $i \n#"
echo -e "remove-node $i \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD
echo -e "\n"
done

echo "######N-Ready Node Delete End  ######"

}

function NodeRegister() {

echo "######Ready Node Register Start######"

NodeName=`hostname`
LocalIP=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
sed -i "s/localhost/$NodeName/g" $UPAS_HOME/nodemanager/upasnm.properties
echo -e "Register $NodeName - $LocalIP #\n"
echo -e "add-java-node $NodeName -host $LocalIP  -port $NM_PORT \nquit\n"| $UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host $UPAS_DAS_SVC_SERVICE_HOST -port $DAS_PORT -u administrator -p $UPAS_PWD
echo -e "\n"

echo "######Ready Node Register End  ######"

}

case $lifeFlag in
1)
   NodePreCheck
   NodeDelete
   NodeRegister ;;
2)
   NodePreCheck
   NodeDelete ;;
*)
   echo "#Please Input LifeCycle Flag (1: Start 2: Stop)" ;;

esac
