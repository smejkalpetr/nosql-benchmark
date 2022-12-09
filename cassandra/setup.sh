#!/bin/bash


echo "[INFO] Starting Cassandra benchmark..."

echo "[INFO] Composing Cassandra cluster..."
# creating cluster of cassandra containers
sudo docker-compose -f cassandra/docker-compose.yml up -d
echo "[INFO] Cassandra cluster composed."

cd YCSB

echo "[INFO] Waiting (2 minutes) for the cluster to be ready..."
# wait for the cluster to be ready (otherwise was getting connection refused)
sleep 120
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

# BENCHMARK WITH WORKLOADS:
for i in {1..3} 
do
    mkdir -p ../output/cassandra/load
    mkdir -p ../output/cassandra/run

    for x in {a..f}
    do
        # LOAD WORKLOADS:
        ./bin/ycsb load cassandra-cql -s -P workloads/workload${x} \
        -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
        -p "cassandra.password=cassandra" \
        -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-${x}-load-${i}.txt

        # RUN WORKLOADS:
        ./bin/ycsb run cassandra-cql -s -P workloads/workload${x} \
        -p "hosts=192.168.5.2,192.168.5.3,192.168.5.4" \
        -p "cassandra.password=cassandra" \
        -p "cassandra.username=cassandra" > ../output/cassandra/load/workload-${x}-load-${i}.txt
    done
done
echo "[INFO] Workloads done."

cd ../

echo "[INFO] Shutting down the docker containers..."
sudo docker-compose -f cassandra/docker-compose.yml down -v
echo "[INFO] Containers have been shut down."

echo "[INFO] Done Cassandra benchmark."