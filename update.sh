#!/bin/sh

sleep 10 #wait untill drill starts

counter=1
while [ $counter -le 10 ]
do
	response=$(curl --write-out %{http_code} --silent --output /dev/null -H "Content-Type: application/json" -X POST  --data "@/dfs.config" http://localhost:8047/storage/dfs.json)
  if [ $response -eq 200 ]
  then
     break
  fi
  sleep 5
  (( counter++ ))
done

echo "=============== Storage Configuration ==============="
curl http://localhost:8047/storage/dfs.json
echo "====================================================="
