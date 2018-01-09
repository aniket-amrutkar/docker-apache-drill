[![Docker Repository on Quay](https://quay.io/repository/falkonry/apache-drill/status "Docker Repository on Quay")](https://quay.io/repository/falkonry/apache-drill)

The following environment variables can be modified and have the following default values:
```
DRILL_MAX_DIRECT_MEMORY=8G
DRILL_HEAP=4G  
DRILL_CLUSTER=drillbit1
```

Other options
```
DRILL_QUERY_ENABLE=true
DRILL_QUERY_LARGE=2
DRILL_QUERY_SMALL=100
DRILL_PLANNER_HASHAGG=false
DRILL_PLANNER_HASHJOIN=false
DRILL_PLANNER_MAX_MEMORY=2147483648
```
The only **compulsory** variable is **ZOOKEEPER** which must be set to the *hostname:port*
