#!/bin/bash

echo "[INFO] Starting Redis benchmark..."

<<<<<<< HEAD
docker compose up -d
=======
docker-compose up -d
>>>>>>> 554b439 (setup + docker-compose)
sudo apt install -y redis-tools
yes 'yes' | redis-cli --cluster fix localhost:6379

for x in {a..f}
do
  echo "[INFO] Running Redis benchmark for workload $x..."
<<<<<<< HEAD
  bin/ycsb.sh load redis -s -P "workloads/workload$x" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > "../outputLoad$x"
  bin/ycsb.sh run redis -s -P "workloads/workload$x" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > "../outputRun$x"
=======
  ./bin/ycsb.sh load redis -s -P "workloads/workload$x" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > "outputLoad$x"
  ./bin/ycsb.sh run redis -s -P "workloads/workload$x" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > "outputRun$x"
>>>>>>> 554b439 (setup + docker-compose)
done
echo "[INFO] Done Redis benchmark."