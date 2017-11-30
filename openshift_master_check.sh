#!/bin/bash
#

#该脚本用于master节点执行安装openshift前做的一个检查

echo "检查ansible是否可以控制全部节点"
ansible all -m ping
echo "查看docker版本，不低于1.12.6"
ansible all -m shell -a "docker version| grep Version"
echo "查看NetworkManager版本不低于1.6、推荐1.8"
ansible all -m shell -a "nmcli --version"
echo "查看系统版本，官方要求（不低于CentOS 7.3, RHEL 7.3, or RHEL 7.4）"
ansible all -m shell -a "cat /etc/redhat-release"
echo "查看各节点的hosts文件"
ansible all -m shell -a "cat /etc/hosts"
echo "查看各节点的NetworkManager是否开启"
ansible all -m shell -a "systemctl status NetworkManager |grep running"
echo "查看各节点的docker是否开启"
ansible all -m shell -a "systemctl status docker |grep running"
echo "查看各节点的firewalld是否关闭"
ansible all -m shell -a "systemctl status firewalld |grep -v running"
echo "查看各节点的SELinux是否开启"
ansible all -m shell -a "getenforce"
echo "查看各节点的时间是否同步，影响etcd的高可用"
ansible all -m shell -a "date"
echo "查看各节点是否完成更改主机名"
ansible all -m shell -a "hostname"
echo "检查ansible版本，不低于2.2"
ansible --version
