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
fill in

Single Packet Authorization
-----
From the CSA documentation:
```One of the primary objectives of the software defined perimeter 
is to make the application infrastructure effectively “black,” or undetectable, 
showing no domain name system (DNS) information or IP addresses.
Single packet authorization (SPA) enables the software defined perimeter 
to reject all traffic to it from unauthorized devices. 
It requires that the first packet to the controller cryptographically verifies 
that it is an authorized device before being considered for access to the protected service. 
If visibility is granted, SPA is utilized again to enable the gateway 
to identify the traffic coming from authorized users and reject all other traffic.```

Mutual Transport Layer Security (mTLS) / IPSEC
-----
fill in

Device Validation
-----
fill in

Application Binding
-----
fill in


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



