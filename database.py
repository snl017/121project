import sqlite3;
from sets import Set

#define a method to update the database.
#day to update given as a all-lower-case, full day of the week
def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
	conn = sqlite3.connect('claremontClock.sqlite3')
	c=conn.cursor()
	#update the database
	updateString = 'UPDATE places SET '+dayToUpdate+'=?, lastUpdate=? WHERE name=?'
	c.execute(updateString,(newHours,timeStamp,nameToUpdate))
	conn.commit()

#returns a list of rows represented as tuples (rowID, name, location, etc...)
#returns only rows that have been updated after the time passed in
def rowsUpdatedLaterThan(time):
	conn = sqlite3.connect('claremontClock.sqlite3')
	c=conn.cursor()
	#list of rows that should be updated, rows represented as tuples
	toReturn = []

	c.execute('SELECT lastUpdate FROM places')
	#list of times to update. note: there may be duplicates
	timesToUpdate = []
	for row in c:
		lastUpdated = float(row[0])
		#if the last update of the database was after the time we're given:
		if lastUpdated>=time:
			#add the string to a list of rows to get
			timesToUpdate.append(row[0])
	#make timesToUpdateSet a set of unique times to update
	timesToUpdateSet = Set(timesToUpdate)
	selectString = 'SELECT * FROM places WHERE lastUpdate=?'
	for time in timesToUpdateSet:
		c.execute(selectString,time)
		for row in c:
			toReturn.append(row)

	conn.commit()
	return toReturn

##The code for creating the database & reading in the static data provided in text files. Needs to be run exactly once to create/fill the database.

conn = sqlite3.connect('claremontClock.sqlite3')
c = conn.cursor()

#Set up the initialization of the database: create our tables.
#These two lines are necessary while we're changing the things we want to input but won't be used once we're updating all the time
c.execute('DROP TABLE IF EXISTS places')
c.execute('DROP TABLE IF EXISTS places')
#We want these lines to stay
c.execute( 'CREATE TABLE IF NOT EXISTS places (rowid INTEGER PRIMARY KEY AUTOINCREMENT, school TEXT, name TEXT, location TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, phone TEXT, email TEXT, link TEXT, extraInfo TEXT, lastUpdate TEXT)')
c.execute('CREATE TABLE IF NOT EXISTS categories (rowid INTEGER PRIMARY KEY AUTOINCREMENT, broad TEXT, specific TEXT, name TEXT)')


#Put the basics of the database in: static!
#Insert items into the places table & add their name to the places list for updates

#the statement to use for inserting into the database
insertPlaceStmt = 'INSERT INTO places (school, name, location, phone, email, link, extraInfo, lastUpdate) VALUES (?, ?, ?, ?, ?, ?, ?, "0")'

#Open the file with information
#Note: each line of the file is a place with "school:name:location:phone:email:link:extraInfo"
placesFiles = open("places.txt", "r")

for line in placesFiles:
    # Parse values
    vals = line.split(":")
    c.execute(insertPlaceStmt, vals)


#Do the same for places into categories.
#Note: each line of the file is a place with "broad:specific:name"
insertToCatStmt = 'INSERT INTO categories (broad, specific, name) VALUES (?, ?, ?)'

categoriesFile = open("categories.txt", "r")

for line in categoriesFile:
	#Parse values
	vals = line.split(":")
	c.execute(insertToCatStmt, vals)

# Done!
conn.commit()

#TESTS:
#test the update statement
#updateDatabase("Frank Dining Hall", "monday", "NEW HOURS", "1")
#Test the rowsToSend method
#rowsToSend = rowsUpdatedLaterThan(1)
#print rowsToSend














