# ipa-scripts

Helper scripts for upstream development on the FreeIPA project

## Workflow

* Get a fresh VM
* Clone the FreeIPA git tree from http://git.fedorahosted.org/cgit/freeipa.git
* Edit ```config/config.sh```
* Run any of ```ipa-SOMETHING.sh``` scripts

## Example scenarios


### Build RPMs, install a server, run unit tests
Build RPMs from current master:  
```$ ./ipa-build.sh```  
Optionally, you can apply a git formatted patch on top of master:  
```$ ./ipa-build.sh --patch /path/to/patch```  
Install the server:  
```$ ./ipa-server.sh```  
Run unit tests:  
```$ ./ipa-test.sh```

### Install a server and a replica
Assuming:  
1. RPMs have already been built and are available at ```$GIT_DIR/dist/rpms/```  
2. Server's fqdn is ```server.example.com``` and replica's fqdn is ```replica.example.com```

(on server):  
Install the server:  
```$ ./ipa-server.sh```  
Prepare the replica file:  
```$ ./ipa-replica-prepare.sh --replica replica.example.com```

(on replica):  
Install the replica:  
```$ ./ipa-replica-install.sh --master server.example.com```

### Install a server and a client
Assuming:  
1. RPMs have already been built and are available at ```$GIT_DIR/dist/rpms/```  
2. Server's IP address is ```10.10.10.10```

(on server):  
Install the server:  
```$ ./ipa-server.sh```

(on client):  
Install the client:  
```$ ./ipa-client.sh --server-ip 10.10.10.10```
