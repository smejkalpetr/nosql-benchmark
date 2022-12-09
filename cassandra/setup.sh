#!/bin/bash


echo "[INFO] Starting Cassandra benchmark..."

echo "[INFO] Composing Cassandra cluster..."
# creating cluster of cassandra containers
sudo docker-compose -f cassandra/docker-compose.yml up -d
echo "[INFO] Cassandra cluster composed."

cd YCSB

echo "[INFO] Waiting (3 minutes) for the cluster to be ready..."
# wait for the cluster to be ready (otherwise was getting connection refused)
sleep 60
echo "[INFO] Cluster is now ready."

echo "[INFO] Creating keyspace in container cassandra1..."
# create keyspace inside cassandra1
sudo docker exec -it cassandra_cassandra1_1 cqlsh 192.168.5.2 -u cassandra -p cassandra -e "CREATE KEYSPACE ycsb WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 2};"
echo "[INFO] Keyspace created."

echo "[INFO] Creating table in keyspace ycsb..."
# create table inside keyspace ycsb
sudo docker exec -it cassandra_cassandra1_1 cqlsh 192.168.5.2 -u cassandra -p cassandra -e "create table ycsb.usertable (
    y_id varchar primary key,
    field0 varchar,
    field1 varchar,
    field2 varchar,
    field3 varchar,
    field4 varchar,
    field5 varchar,
    field6 varchar,
    field7 varchar,
    field8 varchar,
    field9 varchar);"
echo "[INFO] Table in ycsb created."

echo "[INFO] Table created."

echo "[INFO] Starting workloads..."

for i in {1..3} 
do
    mkdir -p ../output/cassandra/load
    mkdir -p ../output/cassandra/run

    # LOAD WORKLOADS:
    # workload A load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloada \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-a-load-${i}.txt

    # workload B load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloadb \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-b-load-${i}.txt

    # workload C load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloadc \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-c-load-${i}.txt

    # workload D load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloadd \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-d-load-${i}.txt

    # workload E load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloade \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-e-load-${i}.txt

    # workload F load 
    ./bin/ycsb load cassandra-cql -s -P workloads/workloade \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-f-load-${i}.txt


    # RUN WORKLOADS:
    # workload A run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloada \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-a-run-${i}.txt

     # workload B run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloadb \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-b-run-${i}.txt

     # workload C run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloadc \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-c-run-${i}.txt

     # workload D run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloadd \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-d-run-${i}.txt

     # workload E run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloade \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-e-run-${i}.txt

     # workload F run 
    ./bin/ycsb run cassandra-cql -s -P workloads/workloadf \
    -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
    -p "cassandra.password=cassandra" \
    -p "cassandra.username=cassandra" > ../output/cassandra/run/workload-f-run-${i}.txt
done
echo "[INFO] Workloads done."

cd ../

echo "[INFO] Shutting down the docker containers..."
docker-compose -f cassandra/docker-compose.yml down -v
echo "[INFO] Containers have been shut down."

echo "[INFO] Done Cassandra benchmark."