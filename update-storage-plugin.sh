#!/usr/bin/env bash
sleep 5
#dfs plugin configuration
hdfs=$(printf '%s\n' "$HDFS_URL" | sed 's:[][\/.^$*]:\\&:g')
pathPrefix=$(printf '%s\n' "$HDFS_DATA_PREFIX" | sed 's:[\/&]:\\&:g;$!s/$/\\/')
echo $hdfs
echo $pathPrefix
sed -i -e "s/HDFS/$hdfs/" /dfs.config
sed -i -e "s/PREFIX/$pathPrefix/" /dfs.config

counter=1
while [ $counter -le 5 ]
do
	response=$(curl --write-out %{http_code} --silent --output /dev/null -H "Content-Type: application/json" -X POST  --data "@/dfs.config" http://localhost:8047/storage/dfs.json)
  if [ response -eq 200 ]
  then
     break
  fi
  sleep 1
  (( counter++ ))
done

echo "Storage Configuration"
curl http://localhost:8047/storage/dfs.json
