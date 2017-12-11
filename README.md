# openshift

ansible_host为master节点上/etc/ansible/hosts文件；

hosts为集群内所有机器的hosts文件；

install_master_openshift.sh为master节点安装上必要组件脚本

openshift_master_check.sh为检查各服务器是否具备安装集群的基本条件

install_node_openshift.sh为node节点必要组件脚本

#安装完验证方法：
1、安装完之后无报错
2、master上执行oc get nodes，查看所有节点的运行情况
3、master上执行oc get all -o wide，查看资源列表，对应的组件是否正常运行

