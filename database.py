import sqlite3
from sets import Set
import os
import helper

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
#returns only rows that have been updated after the time passed in (as a float)
def rowsUpdatedLaterThan(time):
	conn = sqlite3.connect('claremontClock.sqlite3')
	c=conn.cursor()
	#list of rows that should be updated, rows represented as tuples
	updatedRows = []

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
		#print time
		t = (time,)
		c.execute(selectString,t)
		for row in c:
			updatedRows.append(row)
			#print row

	conn.commit()
	return updatedRows


#returns a list of rows represented as tuples (broad categ, specific categ, place name)
#returns all rows that were returned by the updated statement to the database
def rowsCategories(updatedRows) :
	conn = sqlite3.connect('claremontClock.sqlite3')
	c = conn.cursor()

	updatedRowsCopy = [[x] for x in updatedRows]

	categoryRowsToReturn = []
	selectString = 'SELECT * FROM categories WHERE name=?'
	for i in range(len(updatedRows)) :
		place = updatedRows[i]
		#bc place names are saved in category file with a line break at the end
		categoryRowsToReturn = []

		placeName = place[2] + '\n'
		t=(placeName,)
		c.execute(selectString,t)
		for row in c:
			categoryRowsToReturn.append(row)
		updatedRowsCopy[i].append(categoryRowsToReturn)

	print updatedRowsCopy

	conn.commit()
	return updatedRowsCopy

def getScrapingSite(place):
	conn = sqlite3.connect('claremontClock.sqlite3')
	c = conn.cursor()

	selectString = 'SELECT scrapingSite FROM places WHERE name=?'
	t = (place,)
	c.execute(selectString,t)
	for row in c:
		scrapeSite = row

	conn.commit()
	return scrapeSite[0]


#############################################################################################
##The code for creating the database & reading in the static data provided in text files. 
##Needs to be run exactly once to create/fill the database.

conn = sqlite3.connect('claremontClock.sqlite3')
c = conn.cursor()

#Set up the initialization of the database: create our tables.
#These two lines are necessary while we're changing the things we want to input but won't be used once we're updating all the time
c.execute('DROP TABLE IF EXISTS places')
c.execute('DROP TABLE IF EXISTS categories')
#We want these lines to stay
c.execute( 'CREATE TABLE IF NOT EXISTS places (rowid INTEGER PRIMARY KEY AUTOINCREMENT, school TEXT, name TEXT, location TEXT, monday TEXT, tuesday TEXT, wednesday TEXT, thursday TEXT, friday TEXT, saturday TEXT, sunday TEXT, phone TEXT, email TEXT, link TEXT, extraInfo TEXT, lastUpdate TEXT, scrapingSite TEXT)')
c.execute('CREATE TABLE IF NOT EXISTS categories (rowid INTEGER PRIMARY KEY AUTOINCREMENT, broad TEXT, specific TEXT, name TEXT)')


#Put the basics of the database in: static!
#Insert items into the places table & add their name to the places list for updates

#the statement to use for inserting into the database
insertPlaceStmt = 'INSERT INTO places (school, name, location, phone, email, link, extraInfo, lastUpdate, scrapingSite) VALUES (?, ?, ?, ?, ?, ?, ?, "0", ?)'

#Open the file with information
#Note: each line of the file is a place with "school:name:location:phone:email:link:extraInfo"
placesFiles = open("places.txt", "r")

for line in placesFiles:
    # Parse values, that are split by the character sequence "^^^"
    vals = line.split("^^^")
    c.execute(insertPlaceStmt, vals)


#Do the same for places into categories.
#Note: each line of the file is a place with "broad:specific:name"
insertToCatStmt = 'INSERT INTO categories (broad, specific, name) VALUES (?, ?, ?)'

categoriesFile = open("categories.txt", "r")

for line in categoriesFile:
	#Parse values
	vals = line.split("^^^")
	c.execute(insertToCatStmt, vals)




#update places with hardcoded hours
updateString = 'UPDATE places SET monday=?, tuesday=?, wednesday=?, thursday=?, friday=?, saturday=?, sunday=?, lastUpdate=? WHERE name=?'

hardcodedHrsFile = open("hardcoded.txt", "r")

#setting timestamp to 0 so that the app will never try to update these rows after initialized
timeStamp = 0

#right now, while it's not filled in, I'm just getting the first 10 rows
x  = 0
for line in hardcodedHrsFile :
	if(x < 10) :
		#parse values
		nameHours = line.split("~")
		placeName = nameHours[0]
		hours = nameHours[1].split(" ")
		monday = helper.military(hours[0].split(":")[1])
		tuesday = helper.military(hours[1].split(":")[1])
		wednesday = helper.military(hours[2].split(":")[1])
		thursday = helper.military(hours[3].split(":")[1])
		friday = helper.military(hours[4].split(":")[1])
		saturday = helper.military(hours[5].split(":")[1])

		#rstrip removes the new line character at the end of sunday's hours
		sunday = helper.military(hours[6].split(":")[1].rstrip())

		c.execute(updateString,(monday,tuesday,wednesday,thursday,friday,saturday,sunday,timeStamp, placeName))
		x +=1



# Done!
conn.commit()

#TESTS:
#test the update statement, and actually inserts hours so that we can update in the database on the phone
#of course, these hours should initiated by the scraping we do (NEXT STEPPPP)
# formatted as nameToUpdate,dayToUpdate,newHours,timeStamp
# updateDatabase("Frank Dining Hall", "monday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "thursday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "friday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "saturday", "0200-0600%0700-1200", "0")
# updateDatabase("Frank Dining Hall", "sunday", "0200-0600%0700-1200", "1")
# updateDatabase("Frary Dining Hall", "monday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "thursday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "friday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "saturday", "0200-0600%0700-1200", "0")
# updateDatabase("Frary Dining Hall", "sunday", "0200-1200", "0")

#Test the rowsToSend method
#rowsToSend = rowsUpdatedLaterThan(1)
#print rowsToSend













