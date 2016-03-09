NOT READY YET
=====
This project is in it's infancy and not ready for cloning yet.
Contact the author for how best to join in and help.

esdp
=====

esdp (Erlang Software Defined Perimeter) 
is an OTP application 
to provide security for small cloud applets running restful API's.

It's vision is as opensource code to improve security among cloud interactions.

An underlying premise is cloud economics will change design paradigm from large appliance security devices to 
small discrete distributed concurrent atomic functions with well-defined API's.
This work is aimed at restful NextGenNetwork (IpV6) https api's between cloud servers.

esdp is based on the SDP work in the Cloud Security Alliance and consists of:
   - Single Packet Authorization (SPA)
   - Mutual Transport Layer Security (mTLS)
   - Device Validation
   - Dynamic Pinhole Firewalls
   - Application Binding

esdp is still in very early exploratory stages.

The objective would be to build the entire project in erlang.
It's possible this would be sufficient 
but it's also possible some of the bit-banging 
would need to be done in C for speed.
The hope would be the concurrency of erlang would compensate for the speed difference.
However, even if C modules need to be added
the the all-erlang code would be retained as a reference model and for compatibility testing.

Build
-----

    $ rebar3 compile

Environment
-----

The target environment is any cloud. For development and testing, 
the app should also run on and desired workstation.
As the project matures, 
it is hoped to add the necessary API's 
to allow this app to be integrated with any erlang webserver (eg Cowboy/Ranch, webmachine, yaws, ...)
on any cloud (AWS, google, openstack, heroku, ...).
At the moment, it's none of the above yet.

OS
-----
A principle of security is that complexity is evil. 
A corollary to this is that sofware should be kept to the mimimal needed to preform the functionality needed.
Today's operating systems consist of much more than just a kernal - millions of lines of code more.
The eventual goal would be to run this code 
(ie the esdp security code bundled with the api server it is protecting)
on a minimalistic OS that has been reduced down to just the libraries (only erlang?) necessary to run.
In the ideal world the only interfaces to the vm will be https restful api's 
(even for OA&M) and even external ssh would be denied.
The OS used could be any but NixOS (for it's functional config) 
and hardenedBSD (for it's security) 
or some combination (eg a functional config version of hardenedBSD) would be envisioned.
But the project should actually be os independent.

SDP Principles
-----

Dynamic Pinhole Firewalls
-----
From the CSA documentation:

```"Most people are familiar with traditional firewalls that use static configurations to limit incoming and outgoing traffic based on the address information in the IP packet (that is, based on the quintuplet of protocol, source IP address and port, and destination IP address and port). Most enterprise firewalls have ten, hundreds, or even thousands of firewall rules.
Unlike traditional firewalls, dynamic firewalls have only one firewall rule: deny all. Communication with each device is individually enabled by dynamically inserting “Permit <IP quintuplet>” into the firewall policy. In the software defined perimeter architecture, gateways incorporate this dynamic firewall security control.
More specifically, the software defined perimeter dynamically binds users to devices, and then dynamically enables those users to access protected resources by dynamically creating and removing firewall rules in the SDP gateways."```

I.e. the 'dynamic' is associated with the firewall is only opened temporarily (for the initiation of the session). 
The 'pinhole' refers to only allowing an individual entity thu AFTER authorization has occurred 
(with the 3rd party SDP controller). 

For the esdp project there are 'two' firewalls:
* the 'network' firewall, external to the vm in the hypervisor, provided by the cloud system (eg iptables, security groups, etc) via an api
* whatever is implemented in the software

Ideally this project will control both - ie send api calls to the network fw and implement fw in the code running on the vm

Single Packet Authorization
-----
From the CSA documentation:

```"One of the primary objectives of the software defined perimeter 
is to make the application infrastructure effectively “black,” or undetectable, 
showing no domain name system (DNS) information or IP addresses.
Single packet authorization (SPA) enables the software defined perimeter 
to reject all traffic to it from unauthorized devices. 
It requires that the first packet to the controller cryptographically verifies 
that it is an authorized device before being considered for access to the protected service. 
If visibility is granted, SPA is utilized again to enable the gateway 
to identify the traffic coming from authorized users and reject all other traffic."```

One of the decisions the esdp project will need to decide whether to implement SPA in erlang or to wrap
the open source project fwknop (https://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html) in erlang.

Mutual Transport Layer Security (mTLS) / IPSEC
-----
From the CSA documentation:

```"Transport layer security (TLS), also known as secure sockets layer (SSL), 
was designed to provide device authentication prior to enabling confidential communication over the Internet. 
The standard was originally designed to provide mutual device authentication. 
However, in practice, TLS is typically only used to authenticate servers to clients, not clients to servers. 
The software defined perimeter uses the full TLS standard 
to provide mutual, two-way cryptographic authentications."```

Note the edsp project will be using Next Gen Network - ie ipv6 with ipsec. 
But key point is 'mutual' ie both sides need to authenticate.

Device Validation
-----
From the CSA documentation:

```"Mutual TLS proves that the device requesting access to the software defined perimeter 
possesses a private key that has not expired and that has not been revoked, 
but it does not prove that the key has not been stolen. 
Device validation proves that the key is held by the proper device. 
In addition, device validation attests to the fact that the device 
is running trusted software and is being used by the appropriate user."```

For esdp the general version of device validation will be delayed until later. 
The initial functionality will assume a trusted cloud setup of a pre-determined set of cloud vm's.
Note the project will account for the elastic, transitory nature of cloud -
ie the 'pre-determined set' can change. 
VM's can be added, and VM's can be removed.
The esdp code will control the 
More in a later section (elasticiy) on this.

Application Binding
-----
From the CSA documentation:

```"After authenticating and authorizing both the device and the user, 
the software defined perimeter creates encrypted TLS tunnels to the protected applications. 
Application binding constrains authorized applications 
so they can only communicate through those encrypted tunnels, and, 
simultaneously, blocks all other applications from using those tunnels."```

fill in


Elasticity
-----
fill in on how works when machines come and go

Other work to explore for relevance
-----

tools looked at
- cowboy, ranch
- leptus (restful api server)
- all based on gen_tcp (or clones, eg ranch uses proc_lib directly)
  + traced back down thru gen_tecp thru ... to inet-drive.c
  +  otp/erts/emulator/drivers/common/inet_drv.c

- packet erlang links
- fwknop (in C)
   + https://www.cipherdyne.org/fwknop/docs/fwknop-tutorial.html

- epcap
  +  epcap/examples/sniff.erl

- infoblox openflow opensourceRouter=Linc
  + http://www.erlang-factory.com/upload/presentations/635/openflow.soft.switch-krzysztof.rutka.pdf
  + https://github.com/FlowForwarding/LINC-Switch

- ENet - erlang protocol stack
  + https://github.com/archaelus/enet

- Misc links
  + some sample protocol filter code http://erlang.2086793.n4.nabble.com/IP-packet-manipulation-within-Erlang-td2118885.html
  + ACM paper on http in erlang http://dl.acm.org/citation.cfm?id=1088372&dl=GUIDE&coll=GUIDE



