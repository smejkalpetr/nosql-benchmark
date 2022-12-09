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
sudo docker exec -it primary mongosh --eval "rs.initiate({
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
    
    # TODO:


    # LOAD WORKLOADS:
    # workload A load 
    

    # RUN WORKLOADS:
    # workload A run 
done
echo "[INFO] Workloads done."

cd ../

echo "[INFO] Shutting down the docker containers..."
docker-compose -f mongodb/docker-compose.yml down -v
echo "[INFO] MongoDB have been shut down."

echo "[INFO] Done MongoDB benchmark."