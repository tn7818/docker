FROM centos:6.7
MAINTAINER QRS (rongsheng.qu@uprightsoft.cn)
USER root
WORKDIR /root/

#VOLUME ["/home/upas/app"]

#RUN rm -rf /etc/yum.repos.d/*
#COPY files/yum.repos.d/ /etc/yum.repos.d/

# ENV Setting
ENV USER_NAME=upas
ENV USER_HOME=/home/upas LANG=en_US.UTF-8
ENV JAVA_HOME=$USER_HOME/jdk1.7.0_80/
ENV UPAS_HOME=$USER_HOME/upas7 UPAS_DOMAIN=upas_domain DAS_PORT=9736 NM_PORT=7730 UPAS_PWD=upasadmin
ENV PATH=$UPAS_HOME/bin:$UPAS_HOME/lib/system:$JAVA_HOME/bin:$PATH


# Install Shell Expect Support
RUN yum install -y tar* passwd* expect && \
    yum clean all && \
# Change System Params
    echo -e "upas  soft    nofile  32768\nupas  hard    nofile  65536\nupas  soft    noproc  2048\nupas  hard    noproc  4096" >> /etc/security/limit.conf && \
#Create UPAS User && Set userPassword
    useradd -d $USER_HOME $USER_NAME && \
    echo "$USER_NAME" |passwd --stdin $USER_NAME && \

#Copy UPAS Install file && Patches
#COPY files/jdk1.7.0_80_linux_x64.tar.gz \
#     files/upas70fix3_unix_generic_zh_20161121.bin \
#     files/UPAS70fix3_lib_Patch_20170816.tar.gz \
#     files/install.sh $USER_HOME/binary/

    cd $USER_HOME && mkdir binary && cd binary && \
    curl -k -O -B  -L sftp://xxxx/install.sh && \
    curl -k -O -B  -L sftp://xxxx/UPAS70fix3_lib_Patch_20170816.tar.gz && \
    curl -k -O -B  -L sftp://xxxx/upas70fix3_unix_generic_zh_20161121.bin && \
    curl -k -O -B  -L sftp://xxxx/jdk1.7.0_80_linux_x64.tar.gz && \
#Install  JDK && UPAS && PATCH
    tar zxf $USER_HOME/binary/jdk1.7.0_80_linux_x64.tar.gz -C $USER_HOME/ && \
    chmod 750 -R $USER_HOME/binary/install.sh && \
    chmod 750 -R $USER_HOME/binary/upas70fix3_unix_generic_zh_20161121.bin && \
#Install UPAS  (Param: 0->UPAS_HOME 1->SERVER_TYPE[1 DAS 2MS] 2->SERVER_MODE[1PRO 2DEV] 3->JAVA_HOME 4->DAS PASSWORD 5->DOMAIN_NAME 6->Installer File PATH)
    $USER_HOME/binary/install.sh $UPAS_HOME 1 1 $JAVA_HOME $UPAS_PWD $UPAS_DOMAIN $USER_HOME/binary/upas70fix3_unix_generic_zh_20161121.bin  && \
#Install PATCH
    tar zxf $USER_HOME/binary/UPAS70fix3_lib_Patch_20170816.tar.gz -C $UPAS_HOME/lib/ && \
#Set User Profile
    echo -e "# .bash_profile\nif [ -f ~/.bashrc ]; then\n . ~/.bashrc\nelif [ -f /etc/bashrc ]; then\n . /etc/bashrc\nfi\nexport PATH=$PATH:$HOME/bin\n\nexport LANG=$LANG \n" > $USER_HOME/.bash_profile && \
    echo -e "#####JAVA_HOME##########\nexport JAVA_HOME=$USER_HOME/jdk1.7.0_80\nexport PATH=$JAVA_HOME/bin:$PATH\n" >> $USER_HOME/.bash_profile && \
    echo -e "#######UPAS_HOME 7.0 Fix3#########\nexport UPAS_HOME=$UPAS_HOME\nexport PATH=$UPAS_HOME/bin:$UPAS_HOME/lib/system:$PATH\nexport UPAS_DOMAIN=$UPAS_DOMAIN\nalias ua='$UPAS_HOME/bin/upasadmin -domain $UPAS_DOMAIN -host `hostname` -port $DAS_PORT -u administrator -p $UPAS_PWD '\nalias ucfg='cd $UPAS_HOME/domains/$UPAS_DOMAIN/config'\nalias dstart='$UPAS_HOME/bin/startDomainAdminServer -domain $UPAS_DOMAIN -u administrator -p $UPAS_PWD &'\nalias dstop='$UPAS_HOME/bin/stopServer -host `hostname`:$DAS_PORT -u administrator -p $UPAS_PWD'\nalias slogs='cd $UPAS_HOME/domains/$UPAS_DOMAIN/servers'" >> $USER_HOME/.bash_profile && \
#Create UPAS Start/Stop Shell Scripts
     echo -e "#!/bin/bash\n\n\nexport LANG=$LANG\nsu - $USER_NAME -c 'nohup ${UPAS_HOME}/bin/startDomainAdminServer -domain ${UPAS_DOMAIN} -u administrator -p ${UPAS_PWD}  >> $USER_HOME/binary/das.log'\n " > $USER_HOME/binary/dboot && \
     echo -e "#!/bin/bash\n\n\nexport LANG=$LANG\nsu - $USER_NAME -c 'nohup ${UPAS_HOME}/bin/stopServer -host `hostname`:${DAS_PORT} -u administrator -p ${UPAS_PWD}  >> $USER_HOME/binary/das.log'\n " > $USER_HOME/binary/ddown && \
#Change UPAS HOME Files Owner
    chown $USER_NAME:$USER_NAME -R $USER_HOME && \
    chmod 750 $USER_HOME/binary/* && \
#Delete Binary Files
    rm -rf $USER_HOME/binary/install.sh && \
    rm -rf $USER_HOME/binary/*.tar.gz && \
    rm -rf $USER_HOME/binary/*.bin && \
#Reload User Env Profile
    source $USER_HOME/.bash_profile

#Set Listen Port
EXPOSE 9736

#Change User && Workdir
#USER $USER_NAME
#WORKDIR $USER_HOME

#Start UPAS Service
#ENTRYPOINT  /home/upas/binary/dboot
