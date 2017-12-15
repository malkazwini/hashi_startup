#/bin/bash 

#Nomad
echo "Nomad "

docker run -d \
--name nomad \
--net host \
-e NOMAD_LOCAL_CONFIG='{ "server": {
        "enabled": true,
        "bootstrap_expect": 3
    },
    "datacenter": "${DATACENTER}",
    "region": "${REGION}",
    "data_dir": "/nomad/data/",
    "bind_addr": "0.0.0.0",
    "advertise": {
        "http": "${IPV4}:4646",
        "rpc": "${IPV4}:4647",
        "serf": "${IPV4}:4648"
    },
    "enable_debug": true }' \
-v "/opt/nomad:/opt/nomad" \
-v "/var/run/docker.sock:/var/run/docker.sock" \
-v "/tmp:/tmp" \
djenriquez/nomad:v0.6.0 agent

Client:

docker run -d \
--name nomad \
--net host \
-e NOMAD_LOCAL_CONFIG='{ "client": {
        "enabled": true
    },
    "datacenter": "${DATACENTER}",
    "region": "${REGION}",
    "data_dir": "/nomad/data/",
    "bind_addr": "0.0.0.0",
    "advertise": {
        "http": "${IPV4}:4646",
        "rpc": "${IPV4}:4647",
        "serf": "${IPV4}:4648"
    },
    "enable_debug": true }' \
-v "/opt/nomad:/opt/nomad" \
-v "/var/run/docker.sock:/var/run/docker.sock" \
-v "/tmp:/tmp" \
djenriquez/nomad:v0.6.0 agent


echo "Run Consul with UI on port 8500"  

docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap


echo "Run Terraform main.tf should be provided --DISABLED"  

# docker run -i -t hashicorp/terraform:light plan main.tf


echo "Run VAULT check logs for the access token"  

docker run -d --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' -e 'VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:1234' vault


echo "Run Packer--DISABLED" 

#  docker run -i -t hashicorp/packer:light <commad>
