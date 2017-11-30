#!/bin/bash
#

#请将"hosts"文件放在与该脚本同目录下

#开启SELinux
sed -i -e "s/SELINUX=disabled/SELINUX=enforcing/" /etc/selinux/config
#安装依赖及必要的依赖和工具
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum install -y NetworkManager
yum install -y docker
yum install -y iptables iptables-services ipset
#修改docker配置文件
sed -i -e '18s@dockerd-current@dockerd-current --add-registry=master.mabeyx.com:5555 --registry-mirror=https://docker.mirrors.ustc.edu.cn --insecure-registry=172.30.0.0/16@' /usr/lib/systemd/system/docker.service
#关闭firewalld
systemctl stop firewalld
systemctl disable firewalld
#开启NetworkManager
systemctl enable NetworkManager
systemctl restart NetworkManager
#开启iptables
systemctl enable iptables
systemctl start iptables
#开启docker
systemctl enable docker
systemctl start docker

cat hosts >> /etc/hosts

#重启机子，启动SELinux
reboot

#配置/etc/hosts
