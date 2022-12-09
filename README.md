# REVIEW ASSIGNMENT

This repository is used on a remote EC2 instance and is capable of running YCSB workloads to benchmark NoSQL databases (Redis, MongoDB, Cassandra).

In order to run the benchmark run the following command:

`./setup.sh`

When the benchmarks are done, the results can be found in ./output in each corresponding direcotry for a database. Each workload is run three times so that we can get the average times.