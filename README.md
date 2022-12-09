# REVIEW ASSIGNMENT

This repository is used on a remote EC2 instance and is capable of running YCSB workloads to benchmark NoSQL databases (Redis, MongoDB, Cassandra).

In order to run the benchmark, execute the following instructions:

* Create an t2.large EC2 instance (for example in the EC2 dashboard) with Ubuntu on it. Don't forget to set up the key pair (and have the private key on your local machine) and allow inbound for the security group so that you will be able to connect to the instance.

* Connect to the instance via SSH in your terminal:

    `ssh -i path/to/your/private/key.pem ubuntu@public-ip`

* Clone this repository to the insance:

    `git clone https://github.com/smejkalpetr/nosql-benchmark.git`

* Change directory to the repository:

    `cd nonosql-benchmark`

* And start the setup:

    `./setup.sh`

When the benchmarks are done, the results can be found in `./output` in each corresponding direcotry for a database. Each workload is run three times so that we can get the average times.

NOTE: Alternativelly, you can of course run the `setup.sh` script on any unix-like system and run the benchmarks locally. However, if you want to get as close results to our as possible, use the t2.large instance with Ubuntu on it.
