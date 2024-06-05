# EKS ETCD Backup

Configure the correct context

    aws eks update-kubeconfig --region <region> --name <cluster-name>

Identify the ETCD Pods:

    kubectl get pods -n kube-system -l k8s-app=kube-apiserver

Create a Snapshot

    kubectl get pods -n kube-system -l component=etcd

Exec into the etcd Pod:

    kubectl exec -n kube-system <etcd-pod-name> -- sh

Backup the etcd Data:

    ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /opt/snapshot-pre-boot.db 
    Snapshot status snapshot.db

Copy the Snapshot from the Pod to Your Local Machine:

    kubectl cp -n kube-system <etcd-pod-name>:/tmp/snapshot.db ./snapshot.db

Upload the Snapshot to S3

    aws s3 cp ./snapshot.db s3://<your-s3-bucket>/snapshot.db

# Restore from snapshot

Upload the Snapshot to the pod (under a new cluster):

    kubectl cp ./snapshot.db -n kube-system <etcd-pod-name>:/tmp/snapshot.db

Restore the Snapshot:

    etcdctl snapshot restore /tmp/snapshot.db --data-dir=/var/lib/etcd

Restart the etcd Pod:

    kubectl delete pod -n kube-system <etcd-pod-name>
