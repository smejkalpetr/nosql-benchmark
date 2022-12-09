#!/bin/bash


echo "[INFO] Starting MongoDB benchmark..."

echo "[INFO] Composing MongoDB cluster..."
# creating cluster of mongodb containers
sudo docker-compose -f mongodb/docker-compose.yml up -d
echo "[INFO] MongoDB cluster composed."

cd YCSB

echo "[INFO] Waiting (3 minutes) for the cluster to be ready..."
# wait for the cluster to be ready (otherwise was getting connection refused)
sleep 60
echo "[INFO] Cluster is now ready."

echo "[INFO] Starting to create mongodb primary-secodnary replication..."
sudo docker exec -it prim mongosh --eval "rs.initiate({
 _id: \"myRepliet\",
 members: [
   {_id: 0, host: \"192.168.5.2:27017\"},
   {_id: 1, host: \"192.168.5.3:27017\"},
   {_id: 2, host: \"192.168.5.4:27017\"},
   {_id: 3, host: \"192.168.5.5:27017\"}
 ]
})"
echo "[INFO] Finished replication."

echo "[INFO] Starting workloads..."

for i in {1..3} 
do
    mkdir -p ../output/mongodb/load
    mkdir -p ../output/mongodb/run

    # LOAD/RUN WORKLOADS:
    # workload A load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloada \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-a-load-${i}.txt

    # workload A run
    ./bin/ycsb run mongodb-async -s -P workloads/workloada \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-a-run-${i}.txt

    # workload B load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloadb \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-b-load-${i}.txt

    # workload B run
    ./bin/ycsb run mongodb-async -s -P workloads/workloadb \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-b-run-${i}.txt

    # workload C load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloadc \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-c-load-${i}.txt

    # workload C run
    ./bin/ycsb run mongodb-async -s -P workloads/workloadc \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-c-run-${i}.txt

    # workload D load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloadd \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-d-load-${i}.txt

    # workload D run
    ./bin/ycsb run mongodb-async -s -P workloads/workloadd \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-d-run-${i}.txt

    # workload E load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloade \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-e-load-${i}.txt

    # workload E run
    ./bin/ycsb run mongodb-async -s -P workloads/workloadae\
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-e-run-${i}.txt

    # workload F load 
    ./bin/ycsb load mongodb-async -s -P workloads/workloadf \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/load/workload-f-load-${i}.txt

    # workload F run
    ./bin/ycsb run mongodb-async -s -P workloads/workloadf \
    -p mongodb.url=mongodb://192.168.5.2:27017/ycsb?w=0 > ../output/mongodb/run/workload-f-run-${i}.txt
done
echo "[INFO] Workloads done."

cd ../

echo "[INFO] Shutting down the docker containers..."
sudo docker-compose -f mongodb/docker-compose.yml down -v
echo "[INFO] MongoDB have been shut down."

echo "[INFO] Done MongoDB benchmark."