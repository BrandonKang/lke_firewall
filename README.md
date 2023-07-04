# lke_firewall
Terraform script to build and run firewall rules to secure LKE(Linode Kubernetes Engine).

In an LKE cluster, both of the following types of workload endpoints cannot be reached from the Internet:
* Pod IPs, which use a per-cluster virtual network in the range 10.2.0.0/16
* ClusterIP Services, which use a per-cluster virtual network in the range 10.128.0.0/16

All of the following types of workloads can be reached from the Internet:
* NodePort Services, which listen on all Nodes with ports in the range 30000-32768.
* LoadBalancer Services, which automatically deploy and configure a NodeBalancer.
* Any manifest which uses hostNetwork: true and specifies a port.
* Most manifests which use hostPort and specify a port.

Exposing workloads to the public internet through the above methods can be convenient, but this can also carry a security risk. 
You may wish to manually install firewall rules on your cluster nodes. 

The following policies are needed to allow communication between the node pools and the control plane and block unwanted traffic:
* Allow kubelet health checks: TCP port 10250 from 192.168.128.0/17 Accept
* Allow Wireguard tunneling for kubectl proxy: UDP port 51820 from 192.168.128.0/17 Accept
* Allow Calico BGP traffic: TCP port 179 from 192.168.128.0/17 Accept
* Allow NodePorts for workload services: TCP/UDP port 30000 - 32767 192.168.128.0/17 Accept
* Block all other TCP traffic: TCP All Ports All IPv4/All IPv6 Drop
* Block all other UDP traffic: UDP All Ports All IPv4/All IPv6 Drop
* Block all ICMP traffic: ICMP All Ports All IPv4/All IPv6 Drop
* IPENCAP for IP ranges 192.168.128.0/17 for internal communication between node pools and control plane.

This Terraform script enables you quickly set upa firewall with multiple rules to secure your LKE(Linode Kubernetes Engine) clusters.
![image](https://user-images.githubusercontent.com/6391049/226424184-f86b9ee0-b45d-42ca-9199-93d1c9a9147c.png)
![image](https://github.com/BrandonKang/lke_firewall/assets/6391049/a129389f-d858-488c-817f-284b58b2868f)

