FlowBot
===

Ruby bot interacting with Flowdock to complete simple tasks.

It has a plugin system to better extend it. Basically an handler has a ```supports?``` method to register itself on a event type and a ```handle``` method to get the full message.
 
The first plugin (message handler) is the one we are using at Mashape. When someone writes "/me deploying" in the configured flow, it executes a CLI player (afplay) with the sound of a [nuclear alarm](http://www.instantsfun.es/nuclearalarm). 

Yeah I know it's great, but let me know if you have a programmable siren light..