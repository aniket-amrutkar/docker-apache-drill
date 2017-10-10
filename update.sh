#!/bin/bash

#Drill home dir
DRILL_HOME=/opt/drill/apache-drill-${DRILL_VERSION}

#config
QUERY_ENABLE=${DRILL_QUERY_ENABLE:-"true"}
QUERY_LARGE=${DRILL_QUERY_LARGE:-"2"}
QUERY_SMALL=${DRILL_QUERY_SMALL:-"100"}
PLANNER_HASHAGG=${DRILL_PLANNER_HASHAGG:-"false"}
PLANNER_HASHJOIN=${DRILL_PLANNER_HASHJOIN:-"false"}
PLANNER_MAX_MEMORY=${DRILL_PLANNER_MAX_MEMORY:-"2147483648"}
PLANNER_MEMORY_LIMIT=${DRILL_PLANNER_MEMORY_LIMIT:-"1073741824"}
PLANNER_WIDTH_MAX_PER_NODE=${DRILL_PLANNER_WIDTH_MAX_PER_NODE:-"4"}
PLANNER_WIDTH_MAX_PER_QUERY=${DRILL_PLANNER_WIDTH_MAX_PER_QUERY:-"100"}

sleep 10 #wait untill drill starts

counter=1
while [ $counter -le 10 ]
do
	response=$(curl --write-out %{http_code} --silent --output /dev/null -H "Content-Type: application/json" -X POST  --data "@/dfs.config" http://localhost:8047/storage/dfs.json)
  if [ $response -eq 200 ]
  then
     break
  fi
  echo "Response: [${response}]. Retrying #${counter} ..."
  sleep 5
  (( counter++ ))
done

echo "=============== Storage Configuration ==============="
curl http://localhost:8047/storage/dfs.json
echo "====================================================="

echo "================ Updating sys config ================"
{ 
	echo -ne \
	"ALTER SYSTEM SET \`exec.queue.enable\`=${QUERY_ENABLE};\n" \
	"ALTER SYSTEM SET \`exec.queue.large\`=${QUERY_LARGE};\n" \
	"ALTER SYSTEM SET \`exec.queue.small\`=${QUERY_SMALL};\n" \
	"ALTER SYSTEM SET \`planner.enable_hashagg\`=${PLANNER_HASHAGG};\n" \
	"ALTER SYSTEM SET \`planner.enable_hashjoin\`=${PLANNER_HASHJOIN};\n" \
	"ALTER SYSTEM SET \`planner.memory.max_query_memory_per_node\`=${PLANNER_MAX_MEMORY};\n" \
	"ALTER SYSTEM SET \`planner.memory_limit\`=${PLANNER_MEMORY_LIMIT};\n" \
	"ALTER SYSTEM SET \`planner.width.max_per_node\`=${PLANNER_WIDTH_MAX_PER_NODE};\n" \
	"ALTER SYSTEM SET \`planner.width.max_per_query\`=${PLANNER_WIDTH_MAX_PER_QUERY};\n" \
	"!quit\n" ; cat ; \
} | ${DRILL_HOME}/bin/drill-conf
