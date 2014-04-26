from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
import constants
import database
import json
import os


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
		#this is how we will ACTUALLY need to do this, 
		#but for right now we're just testing to see if ANY rows get updated
		#rowsToSend = database.rowsUpdatedLaterThan(self.lastTime) 
		#for row in rowsToSend:
		#self.sendMessage(row)

		if (self.lastTime >= 0) :
			#debugging stuff, so that something hasn't been updated at TIME:0
			rows = database.rowsUpdatedLaterThan(0)	

			#this just does the first 4 places to update, because they are the only ones with initialized hours in the database
			rows = rows[0:6]

			#print json.dumps(rows)

			#now we're back to actual code we keep for GOOD
			self.transport.write(json.dumps(rows))
			self.transport.loseConnection()

		else: 
		#time stamp will be -1 and we need to send category info TOO
			print "time stamp is -1!"
			rows = database.rowsUpdatedLaterThan(self.lastTime)
			rows.append(database.rowsCategories())
			print json.dumps(rows)
			#self.transport.write(json.dumps(rows))
			#self.transport.loseConnection()




factory = Factory()
factory.clients = []
factory.protocol = DatabaseServer
reactor.listenTCP(80, factory)
print "DatabaseServer started"
os.system("python scraper.py")

reactor.run()