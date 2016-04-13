=====
This use case is a variant off the base use case. 
The particular focus of this use case is describing the steady state
communications between the webserver and the application server.

The relevant control in this case is the already established IPSEC connection
between the relevant application on the webserver 
and the relevant application.

![big picture no captions](esdp_03.jpg?raw=true "Big Picture")

For this use case it is assumed the infrastructure established this connection as part of spinning up these machines 
(details in another use case).

Prior to this use case, the user intiated some action that caused the webserver to wish to invoke an api to the application server.
The code "W" is invoked to make the api call over the IPSEC link to the code "A" in the application server.
One of the apps in esdp is the comms module which contains an gen_server which had been previously instantiated 
as part of spinning up the webserver and appserver routines and that code is bound to the appropriate calling/receiving routines.
In other words the software in the webserver that needs to access the api knows pid of the send_api gen_server and 
sends the handle_call to invoke the api desired.

On the other end of the link, in the "A" software, is the instantiation of the rcv_api gen_server 
whose handle_call does whatever it is this api does and replies back through the link.

add pic showing underlying sw arch

