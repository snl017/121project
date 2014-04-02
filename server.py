from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class DatabaseServer(Protocol):
	def connectionMade(self):
		self.factory.clients.append(self)
		print "clients are ", self.factory.clients #this print statement was in the tutorial. I'm not sure whether we keep it.

	def connectionLost(self, reason):
		#for debugging:
		#print "removing ", self
		#
		self.factory.clients.remove(self)

	#Take timeStamp of last update 
	#timestamp received as a string "TIME:<time stamp>"
	def dataReceived(self,data):
		timeStamp = data.split('TIME:') 
		#if we have a correctly formatted TIME input string:
		if len(timeStamp) > 1:
			#Save the time stamp passed in 
			self.lastTime = timeStamp[1]
			print self.lastTime #for debugging, but also not necessarily bad
			#call getData to send data back to the client
			self.getData() 

	def getData(self):
		#for each possible thing to update:
		#check whether it needs to be updated using a timestamp
		#if it does:
		#package it into a JSON
		self.sendMessage(self.lastTime) #temporarily send the timeStamp sent in. Eventually it'll be a set of hours.

	def sendMessage(self,message):
		self.transport.write(message + '\n') #this is a string. I don't know how to use JSON.
		#for debugging: 
		#print "message sent to", self
		#


factory = Factory()
factory.clients = []
factory.protocol = DatabaseServer
reactor.listenTCP(80, factory)
print "DatabaseServer started"
reactor.run()