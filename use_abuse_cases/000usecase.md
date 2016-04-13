=====
This use case is the big picture use case. 
A person, using their device, accesses (over the internet) some cloud resources.
The overall objective is to add eSDP as security controls not this architecture.

![big picture no captions](esdp_01.jpg?raw=true "Big Picture")

Use Case 000 - Big Picture
=====

Adding some more detail. 
Some cloud resources 
(in this case a typical 3-tier architecture of 
a webserver, application server, and a database) 
are available to a user device via an api. 

![big picture](esdo_02.jpg?raw=true "Title")

The resources being accessed are in the cloud and reside on 3 virtual machines.
The client device accesses the cloud over the wild internet.
The cloud resources are controlled/orchestrated 
by a combination of infrastructure api's 
and a esdp controller (more in specific use cases).

The base use case is static, steady state, and simple. 
Other use cases will elastic up/down the size, deal with startup/shutdown,
and handle the other complex cases.

For simplicity, the various SDP principles will be introduced each in their 
own use case. The principles are:

* Single Packet Authorization (SPA)
* Mutual Transport Layer Security (mTLS)
* Device Validation
* Dynamic Pinhole Firewalls
* Application Binding

See the overall README for the list of usecases and abuse cases
