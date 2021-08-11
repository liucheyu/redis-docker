#!/bin/bash
while getopts f:c:p:n:h: flag
do
    case "${flag}" in
        f) confInput=${OPTARG};;
        c) customizeInput=${OPTARG};;
        p) portInput=${OPTARG};;
        n) nodesInput=${OPTARG};;
        h) hostInput==${OPTARG};;
    esac
done

confPath=$(pwd)"/conf"
if [ -z "$confInput" ]
then
    read -p "please insert the conf path.(default is $confPath)." confInput
    if [ -z "$confInput" ] 
    then
        echo "use $confPath by default."
    else
        confPath=$confInput
        echo "use $confparent."
    fi
fi


customizePath=$(pwd)"/customize"
if [ -z "$customizeInput" ]
then
    read -p "please insert the customize path.(default is $customizePath)." customizeInput
    if [ -z "$customizeInput" ]
    then
        echo "use $customizePath by default."
    else
        customizePath=$customizeInput 
        echo "use $customizePath."
    fi
fi 

startPort=6379
if [ -z "$portInput" ]
then
    read -p "please insert the cluster port start from.(default is $startPort)." portInput
    if [ -z "$portInput" ]
    then
        echo "use $startPort at start of the cluster port by default."
    else
        startPort=$portInput
        echo "use $startPort at start of the cluster port."
fi

nodes=6
if [ -z "nodesInput" ]
then
    read -p "please insert the nodes count.(default is $nodes)." nodesInput
    if [ -z "nodesInput" ]
    then
        echo "use $nodes nodes by default."
    else
        nodes=$portInpunodesInputt
        echo "use $nodes nodes."     
fi

ip=$(sudo docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}')
if [ -z "hostInput" ]
then
    read -p "please insert the host ip.(default is $ip)." hostInput
    if [ -z "hostInput" ]
    then
        echo "use $ip by default."
    else
        ip=$hostInput
        echo "use $ip."     
fi

clusterIps="";
maxport=$(($startPort+$nodes-1));
for ((i=$startPort;i<=$maxport;i++))
do
  port=$i;
  clusterIps=" $clusterIps $ip:$port";
  #echo $clusterIps;
  if [ ! -d "/home/liucheyu/docker/redis/customize$port" ];then
    sudo mkdir -p $customizePath$port
    sudo cp -R /home/liucheyu/docker/redis/customize/* $customizePath$port
  fi  
  sudo chmod 755 -R  $customizePath$port
  OUTPUT=`sudo docker run --rm -d -p $port:$port -p 1$port:1$port -v $confPath:/usr/local/etc/redis/conf -v $customizePath$port:/usr/local/etc/redis/customize  --name redis$port redis:6.2.5-alpine redis-server /usr/local/etc/redis/customize/redis.conf --port $port --cluster-announce-ip $ip --cluster-announce-port $port`
  echo $OUTPUT;
done

OUTPUT = `sudo docker exec -it redis$startPort sh -c "echo 'yes'|redis-cli --cluster create $clusterIps --cluster-replicas 1"`
echo OUTPUT;
