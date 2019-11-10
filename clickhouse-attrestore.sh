#!/bin/sh
###########################################################
####Restore FREEZE PARTITION table 
#Author:joe
#Date: 20191110
###########################################################

clickhouse_client=`which clickhouse-client`

help()
{
cat <<EOF
Usage:$0 -h hostname -P port -u user [-p password] -d database -t table detachedir
    -h :Connect clickhouse-server houstname
    -P :Connect clickhouse-server port
    -u :Connect clickhouse-server username
    [-p] :Connect clickhouse-server password,default null
    -d :Attach database
    -t :Attach table
EOF
}

attachQuery()
{
table=$1
path=$2
partpath=$(ls -d ${path/%\//}/*/)
querys=''
for line in $partpath
do 
  part=$(cat ${line}"partition.dat")
  part=$(echo $part)
  sql="alter table $table ATTACH PARTITION ""'$part'"
  if [ -n "$querys" ];then
    querys="$querys"";$sql"
  else
    querys="${querys}"$sql
  fi
done
echo "$querys"
}

attachRestore()
{
argnum=$1
host=$2
port=$3 
user=$4
attdir=`echo $@|awk '{print $NF}'`
if [ $argnum -eq 11 ];then 
 database=$5
 table=$6
 query=`attachQuery $table $attdir`
 $clickhouse_client -h $host --port $port -d $database -u $user -n --query="$query"
elif [ $argnum -eq 12 ];then
 database=$5
 table=$6
 query=`attachQuery $table $attdir`
 $clickhouse_client -h $host --port $port -d $database -u $user --password -n --query="$query"
elif [ $argnum -eq 13 ];then
 passwd=$5
 database=$6
 table=$7
 query=`attachQuery $table $attdir`
 $clickhouse_client -h $host --port $port -d $database -u $user --password $passwd -n --query="$query"
else
 :
fi   
}

attdir=`echo "$@"|awk '{print $NF}'`
if [ $# -eq 11 ];then
 while getopts "h:P:u:d:t:" opt
 do
  case $opt in
     h)
      hostname=$OPTARG 
      ;;
     P)
      port=$OPTARG
      ;;
     u)
      user=$OPTARG
      ;;
     d)
      database=$OPTARG
      ;;
     t)
      table=$OPTARG
      ;;
     *)
      help
      exit 1
     ;;
  esac
 done
elif [ $# -eq 12 ];then
 while getopts "h:P:u:d:t:p" opt
 do
  case $opt in
     h)
      hostname=$OPTARG
      ;;
     P)
      port=$OPTARG
      ;;
     u)
      user=$OPTARG
      ;;
     d)
      database=$OPTARG
      ;;
     t)
      table=$OPTARG
      ;;
     p)
      passwd=$OPTARG
      ;;
     *)
      help
      exit 1
     ;;
  esac
 done
elif [ $# -eq 13 ];then
 while getopts "h:P:u:d:t:p:" opt
 do
  case $opt in
     h)
      hostname=$OPTARG
      ;;
     P)
      port=$OPTARG
      ;;
     u)
      user=$OPTARG
      ;;
     d)
      database=$OPTARG
      ;;
     t)
      table=$OPTARG
      ;;
     p)
      passwd=$OPTARG
      ;;
     *)
      help
      exit 1
     ;;
  esac
 done
else
 help
fi
attachRestore $# $hostname $port $user $passwd $database $table $attdir
