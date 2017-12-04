#!/bin/bash
#

#该脚本用于实现Openshift_master节点上必要服务的安装

#请将"ansible_host"  "hosts"文件放在与该脚本同目录下

#开启SELinux
sed -i -e "s/SELINUX=disabled/SELINUX=enforcing/" /etc/selinux/config
#安装依赖及必要的依赖和工具
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion
#安装NetworkManager
yum install -y NetworkManager
yum install -y docker
yum install -y iptables iptables-services ipset
#yum install -y java-1.8.0-openjdk-headless python-urllib3-1.10.2-3.e17.noarch
yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
yum install -y ansible pyOpenSSL
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
mv /etc/ansible/hosts /etc/ansible/hosts.bak
touch /etc/ansible/hosts
cat ansible_host > /etc/ansible/hosts

#下载安装配置文件
cd ~
git clone https://github.com/openshift/openshift-ansible

#重启机子，启动SELinux
reboot

#安装本地仓库，按需求安装。如已有仓库或想直接使用openshift提供的仓库则可注释
mkdir -p /data/registry
docker run -d -p 5555:5000 --restart=always --name registry -v /data/registry:/var/lib/registry  registry:2

#请注意、以下内容可能需要手动操作

#使用ansible安装集群
#ansible-playbook ~/openshift-ansible/playbooks/byo/config.yml
#授权master与node见的信任关系
#ssh-keygen
#ssh-copy-id -i ~/.ssh/id_rsa.pub master.mabeyx.com
#配置信赖关系
#/etc/host
#配置ansible安装目标
#/etc/ansible/hosts
#更改各节点主机名称
#hostnamectl set-hostname  master.mabeyx.com
