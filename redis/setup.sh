#!/bin/bash

echo "[INFO] Starting Redis benchmark..."

echo "[INFO] Composing Redis cluster..."
# creating cluster of redis containers
sudo docker-compose -f redis/docker-compose.yml up -d
echo "[INFO] Redis cluster composed."

cd YCSB

echo "[INFO] Waiting (2 minutes) for the cluster to be ready..."
# wait for the cluster to be ready (otherwise was getting connection refused)
sleep 120
echo "[INFO] Cluster is now ready."

echo "[INFO] Installing required tools and configuring up cluster..."
sudo apt install -y redis-tools
yes 'yes' | redis-cli --cluster fix localhost:6379
echo "[INFO] Cluster is now set up."

echo "[INFO] Starting workloads..."
# BENCHMARK WITH WORKLOADS:
for i in {1..3} 
do
    mkdir -p ../output/redis/load
    mkdir -p ../output/redis/run

    for x in {a..f}
    do
        # LOAD WORKLOADS:
        ./bin/ycsb.sh load redis -s -P "workloads/workload${x}" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > ../output/redis/load/workload-${x}-load-${i}.txt

        # RUN WORKLOADS:
        ./bin/ycsb.sh run redis -s -P "workloads/workload${x}" -p "redis.host=127.0.0.1" -p "redis.port=6379" -p "redis.cluster=true" > ../output/redis/run/workload-${x}-load-${i}.txt
    done
done
echo "[INFO] Workloads done."

cd ../

echo "[INFO] Shutting down the docker containers..."
sudo docker-compose -f redis/docker-compose.yml down -v
echo "[INFO] Redis have been shut down."

echo "[INFO] Done Redis benchmark."