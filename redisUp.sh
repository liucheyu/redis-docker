#!/bin/bash
startPort=6379;
ip="172.18.27.188";
nodeCount=6;
clusterIps="";
maxport=$(($startPort+$nodeCount-1));

for ((i=$startPort;i<=$maxport;i++))
#for port in {$startPort..$maxport};
do
  port=$i;
  clusterIps=" $clusterIps $ip:$port";
  #echo $clusterIps;
  if [ ! -d "/home/liucheyu/docker/redis/customize$port" ];then
    sudo mkdir -p /home/liucheyu/docker/redis/customize$port
    sudo cp -R /home/liucheyu/docker/redis/customize/* /home/liucheyu/docker/redis/customize$port
  fi  
  sudo chmod 777 -R  /home/liucheyu/docker/redis/customize$port
  sudo chmod 777 -R  /home/liucheyu/docker/redis/customize$port

  OUTPUT=`sudo docker run --rm -d -p $port:$port -p 1$port:1$port -v /home/liucheyu/docker/redis/conf:/usr/local/etc/redis/conf -v /home/liucheyu/docker/redis/customize$port:/usr/local/etc/redis/customize  --name redis$port redis:6.2.5-alpine redis-server /usr/local/etc/redis/customize/redis.conf --port $port --cluster-announce-ip $ip --cluster-announce-port $port`
  
  echo $OUTPUT;

done

sudo docker exec -it redis$startPort sh -c "echo 'yes'|redis-cli --cluster create $clusterIps --cluster-replicas 1"
