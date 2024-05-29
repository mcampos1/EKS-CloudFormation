# ETCD backup
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db
Snapshot status snapshot.db


Ssh into controlplane node of cluster1
ETCDCTL_API=3 etcdctl 
--endpoints=https://10.1.220.8:2379 
--cacert=/etc/kubernetes/pki/etcd/ca.crt 
--cert=/etc/kubernetes/pki/etcd/server.crt 
--key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/cluster1.db
scp cluster1-controlplane:/opt/cluster1.db /opt
