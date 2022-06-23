myalgonode
==========

A containerised algorand node automated startup which will use fast catchup if required.

## Prerequistes ##

[Docker](https://www.docker.com/) must be installed

Hardware 4-8GB RAM, 100GB SSD, 10Mbit broadband, 4 cores (you can underclock the hardware CPU/broadband but your node may fall behind)

## Usage ##

get the image

```bash
docker pull twwsw/myalgonode
```

create a volume for the node data. This is recommended so restarting the node doesn't mean a blockchain download is required

```bash
docker volume create --name algodata
```

Run the node, here the port 9001 is used on the host machine to expose the service. ALGORAND_NETWORK can be set to testnet or betanet. --mount can be skipped if you are not using a volume

```bash
docker run --name mynode  -p 9001:8080 -d -e ALGORAND_NETWORK=mainnet --mount type=volume,source=algodata,dst=/root/node/data -t myalgonode:latest
```

Check the logs

```bash
docker logs mynode
```

check the node status with

```bash
docker exec -it mynode goal node status
```
When the node is fully up the status looks similar to the below
```
Last committed block: 21793688
Time since last block: 1.6s
Sync Time: 0.0s
Last consensus protocol: https://github.com/algorandfoundation/specs/tree/d5ac876d7ede07367dbaa26e149aa42589aac1f7
Next consensus protocol: https://github.com/algorandfoundation/specs/tree/d5ac876d7ede07367dbaa26e149aa42589aac1f7
Round for next consensus protocol: 21793689
Next consensus protocol supported: true
Last Catchpoint:
Genesis ID: mainnet-v1.0
Genesis hash: wGHE2Pwdvd7S12BL5FaOP20EGYesN73ktiC1qzkkit8=
```

When the node is stood up the AlgoD API can be called to get the swagger API

```bash
http://localhost:9001/swagger.json
```



## More info ##

[How to take part in concensus](https://developer.algorand.org/docs/run-a-node/participate/)
[The Algod v2 API](https://developer.algorand.org/docs/rest-apis/algod/v2/)


