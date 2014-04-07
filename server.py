from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
import constants
import database
import json


class DatabaseServer(Protocol):
	def connectionMade(self):
		self.factory.clients.append(self)
		print "clients are ", self.factory.clients #this print statement was in the tutorial. I'm not sure whether we keep it.

	def connectionLost(self, reason):
		self.factory.clients.remove(self)

	#Take timeStamp of last update 
	#timestamp received as a string "TIME:<time stamp>"
	def dataReceived(self,data):
		timeStamp = data.split('TIME:') 
		#if we have a correctly formatted TIME input string:
		if len(timeStamp) > 1:
			#Save the time stamp passed in 
			self.lastTime = float(timeStamp[1])
			print self.lastTime #for debugging, but also not necessarily bad
			#call getData to send data back to the client
			self.getData() 

	def getData(self):
		#for each possible thing to update:
		#check whether it needs to be updated using a timestamp

		#get a list of the rows to be updated (represented as a tuple)
		rowsToSend = database.rowsUpdatedLaterThan(self.lastTime) 
		for row in rowsToSend:
			self.sendMessage(row)

		#debugging stuff, so that something hasn't been updated at TIME:0
		rows = database.rowsUpdatedLaterThan(0)	
		#this just does the first 2 places to update, because they are the only ones with initialized hours in the database
		rows = rows[0:2]

		#now we're back to actual code we keep for GOOD
		self.transport.write(json.dumps(rows))
		self.transport.loseConnection()

	#message is a tuple representing a row
	#packages it into a JSON
	#sends the information to the client
	def sendMessage(self,message):
		#for debugging:
		#print message
		#example message:
		#(2, u'Pomona College', u'Frank Dining Hall', u'Pomona', None, None, None, None, None, None, None, u'(###)###-####', u'', u'frank.google.com', u'closed Fridays!\n', u'0')
		#here, json.dumps transforms the tuple into an array that is a JSON formatted string
		jsonOBJ = json.dumps(message)
		self.transport.write(jsonOBJ + '\n')


		#self.transport.write("getting data!" + '\n') #needs modification. This just sends a string whenever the server wants to be sending a message
		#for debugging: 
		#print "message sent to", self



factory = Factory()
factory.clients = []
factory.protocol = DatabaseServer
reactor.listenTCP(80, factory)
print "DatabaseServer started"
reactor.run()