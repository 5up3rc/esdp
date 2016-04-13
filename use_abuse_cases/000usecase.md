=====
This use case is the big picture use case. 
A person, using their device, accesses (over the internet) some cloud resources.
The overall objective is to add eSDP as security controls to this architecture.

![big picture no captions](esdp_01.jpg?raw=true "Big Picture")

Use Case 000 - Big Picture
=====

This figure adds some more detail to distinquish the types of interfaces. 
There are two types of cloud resources - one accessed from the client and one 'internal to the cloud'.
Examples would be the appserver and dbserver in a typical 3-tier architecture of 
a webserver, application server, and a database where just the webserver has client access. 

![big picture](esdp_02.jpg?raw=true "Title")

The resources being accessed are in the cloud and reside on 2 virtual machines and a distinction is being made
between the types of interfaces (accessed via client device over the wild internet vs accessed from another cloud server).
The cloud resources are controlled/orchestrated 
by a combination of infrastructure APIs
(more in specific use cases).

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
