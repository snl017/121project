import urllib2
from urllib2 import urlopen
from bs4 import BeautifulSoup
import re
import string
import database

###DO NOT USE
###created by Shannon while she and Anna were working simulatenously
###ALL work in scraper.py now 


#Created by Shannon Lubetich
#4/15/2014



#This is a testing section. We get the url and open it below.
# testURL = "http://flrc.pomona.edu/"
# html = urlopen(testURL).read()
# soup = BeautifulSoup(html)

#Then we look for the Hours of Operation Section
# test = soup.find_all('li', text = (re.compile("Tuesday.") or re.compile("Tuesday.")))






#helper method for calculating military time
#returns an ordered pair of strings
#the first is a string of the hour digits (0-24)
#the second elt is a string of the minute digits (0-59)
def extractHoursMinutes(n):
	if len(n) == 3 :
		return (n[:1], n[1:])
	elif len(n) == 4 :
		return (n[:2], n[2:])
	else :
		return (n, "0")

#Wrapper Function - put hours into database-friendly military time
#Accepts a BeautifulSoup Object String
#returns a string
def military(n):
	#make string from BeautifulSoup object
	encoded = n.encode('utf-8')
	#eliminate symobls from string
	formatted = encoded.translate(None, ' .:')

	#make unicode, eliminate spaces, then turn back into string
	uniString = unicode(formatted, "UTF-8")
	uniString = uniString.replace(u"\u00A0", "")
	strFormat = str(uniString.encode('utf-8'))

	#convert to lowercase, replace Keywords
	strFormat = strFormat.lower()
	strFormat = strFormat.replace("midnight", "2400am")
	strFormat = strFormat.replace("noon", "1200pm")

	#Using regex, get array of all groups of digits
	numbersPattern = re.compile("\d+")
	numbersArray = numbersPattern.findall(strFormat)

	#Using regex, get array of all groups of letters (will be am/pm)
	amPmPattern = re.compile("[a-zA-Z]+")
	amPmArray = amPmPattern.findall(strFormat)

	#go through all numbers, format correctly into 4-digit military time
	formattedHours = []
	for i in range(len(numbersArray)):
		time = numbersArray[i]
		hr_min = extractHoursMinutes(time)
		hrDigits = int(hr_min[0])
		minDigits = int(hr_min[1])
		#handle if is PM and needs to be converted to military time
		if(amPmArray[i] == "pm") :
			hrDigits = (hrDigits%12) + 12
		#calulate full digits
		fullDigits = hrDigits*100+minDigits
		#convert to string
		fullHours = str(fullDigits)
		#add leading 0 if is only 3 characters lon
		if len(fullHours) == 3 :
			fullHours = "0" + fullHours
		formattedHours.append(fullHours)
	#build final string of opening-closing
	finalHourString = formattedHours[0]+"-"+formattedHours[1]
	return finalHourString



#TODO - this function gives us multiple hour sets if need be
#def parseHourSets(n)


#HONNOLD CAFE
#Test with http://aspc.pomona.edu/eatshop/on-campus/
eatshopURL = "http://aspc.pomona.edu/eatshop/on-campus/"
eatshopHTML = urlopen(eatshopURL).read()
eatshopSoup = BeautifulSoup(eatshopHTML)

eatshopHonnold = eatshopSoup.find('h2', text = (re.compile("Honnold Caf."))).parent
eatshopHonnoldArray = eatshopHonnold.descendants


#Find the <dl> tag that has hours in it
for elt in eatshopHonnoldArray:
	eatshopHonnoldHours = elt.find('dl')
	if(eatshopHonnoldHours != None and eatshopHonnoldHours != -1):
		break


arrayOfDayStrings = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]
dictOfDaysToHours = {}

for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"
	#if the name of the day is explicitly here, then access hours
	desiredSection = eatshopHonnoldHours.find(text = re.compile(dayRegex))
	if desiredSection :
		dayElt = desiredSection.parent.next_sibling.next_sibling #first nextsibling gives whitespace
		dayHours = military(dayElt.string)
		dictOfDaysToHours[day] = dayHours

#temporary way of accounting for "Mon - Thurs"
"""TODO: deal with something says "closed", or if hours are simply just not listed for that day if it is closed"""
currHourSet = ""
for day in arrayOfDayStrings :
	if day in dictOfDaysToHours.keys()  :
		currHourSet = dictOfDaysToHours[day]
	else : 
		dictOfDaysToHours[day] = currHourSet

#now I need to know how to update the database on the server based on this info. hey update statements? 
#def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
databaseDayStrings = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Honnold Cafe", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")
	#UHHH PROBLEM. i'm assuming we need to get the timestamp of when we're updating this, 
	#and that's going to need to be basically the same "time since 1972"??? what was it??? 




################################################################################
#now i'm doing this for the coop fountain
eatshopCoopFountain = eatshopSoup.find('h2', text = (re.compile("Coop Fountain"))).parent
eatshopCoopFountainArray = eatshopCoopFountain.descendants

#Find the <dl> tag that has hours in it
for elt in eatshopCoopFountainArray:
	eatshopCoopFountainHours = elt.find('dl')
	if(eatshopCoopFountainHours != None and eatshopCoopFountainHours != -1):
		break

dictOfDaysToHours.clear()
for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"
	#if the name of the day is explicitly here, then access hours
	desiredSection = eatshopCoopFountainHours.find(text = re.compile(dayRegex))
	if desiredSection :
		dayElt = desiredSection.parent.next_sibling.next_sibling #first nextsibling gives whitespace
		dayHours = military(dayElt.string)
		dictOfDaysToHours[day] = dayHours

#temporary way of accounting for "Mon - Thurs"
"""TODO: deal with something says "closed", or if hours are simply just not listed for that day if it is closed"""
currHourSet = ""
for day in arrayOfDayStrings :
	if day in dictOfDaysToHours.keys()  :
		currHourSet = dictOfDaysToHours[day]
	else : 
		dictOfDaysToHours[day] = currHourSet

#now I need to know how to update the database on the server based on this info. hey update statements? 
#def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
databaseDayStrings = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Coop Fountain", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")



#######################################################################################
###COOP STORE
coopStoreURL = "http://coopstore.pomona.edu"
coopStoreHTML = urlopen(coopStoreURL).read()
coopStoreSoup = BeautifulSoup(coopStoreHTML)

coopStoreHours = coopStoreSoup.find('h2', text = (re.compile("Hours"))).parent

dictOfDaysToHours.clear()
for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"
	#if the name of the day is explicitly here, then access hours
	desiredSection = coopStoreHours.find(text = re.compile(dayRegex))
	if desiredSection :
		dayElt = desiredSection.parent.next_sibling.next_sibling #first nextsibling gives whitespace
		dayHours = military(dayElt.string)
		dictOfDaysToHours[day] = dayHours

#temporary way of accounting for "Mon - Thurs"
"""TODO: deal with something says "closed", or if hours are simply just not listed for that day if it is closed"""
currHourSet = ""
for day in arrayOfDayStrings :
	if day in dictOfDaysToHours.keys()  :
		currHourSet = dictOfDaysToHours[day]
	else : 
		dictOfDaysToHours[day] = currHourSet

#now I need to know how to update the database on the server based on this info. 
#def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
databaseDayStrings = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Coop Store", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")


################################################################################
#WRITING CENTER
writingCenterURL = "https://my.pomona.edu/ICS/Academics/Writing_Center_Page.jnz"
writingCenterHTML = urlopen(writingCenterURL).read()
writingCenterSoup = BeautifulSoup(writingCenterHTML)

writingCenterHours = writingCenterSoup.find(text = (re.compile("Writing Center.*hours"))).parent

dictOfDaysToHours.clear()
for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"
	#if the name of the day is explicitly here, then access hours
	desiredSection = writingCenterHours.find(text = re.compile(dayRegex))
	if desiredSection :
		#Using regex, get hours from long sentence
		hrsPattern = re.compile("\d+.*\d+.*\s")
		hrsArray = hrsPattern.findall(desiredSection)
		dayElt = hrsArray[0]
		openClose = dayElt.split("-")
		dayElt = openClose[0] + "pm-" + openClose[1]
		dayHours = military(dayElt)
		dictOfDaysToHours[day] = dayHours
	dictOfDaysToHours["Mon"] = dayHours
	dictOfDaysToHours["Fri"] = "Closed"


#temporary way of accounting for "Mon - Thurs"
"""TODO: deal with something says "closed", or if hours are simply just not listed for that day if it is closed"""
currHourSet = ""
for day in arrayOfDayStrings :
	if day in dictOfDaysToHours.keys()  :
		currHourSet = dictOfDaysToHours[day]
	else : 
		dictOfDaysToHours[day] = currHourSet



#now I need to know how to update the database on the server based on this info. 
#def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
databaseDayStrings = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Writing Center", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")







################################################################################
#FRANK AND FRARY#
#WORK IN PROGRESS#

# poDiningURL = "http://www.pomona.edu/administration/dining/facilities-hours/hours.aspx"
# poDiningHTML = urlopen(poDiningURL).read()
# poDiningSoup = BeautifulSoup(poDiningHTML)

# poDiningFrank = poDiningSoup.find('h2', text = (re.compile("Frank")))

# #get mon-thurs section with by finding next next sibling (next sibling is white space)
# poDiningFrankHoursWeek = poDiningFrank.next_sibling.next_sibling
# poDiningFrankHoursWeekend = poDiningFrankHoursWeek.next_sibling.next_sibling

# dictOfDaysToHours.clear()
# for day in arrayOfDayStrings : 
# 	dayRegex = ".*" + day + ".*"
# 	#if the name of the day is explicitly here, then access hours
# 	desiredSection = poDiningFrankHours.find(text = re.compile(dayRegex))
# 	if desiredSection : 
# 		if "closed" in desiredSection.lower() :
# 			#TODO: set to closed
# 			break
# 		else: 
# 			breakfast = desiredSection.parent.parent.next_sibling.next_sibling.next_sibling.next_sibling #first nextsibling gives whitespace
# 			breakfastTime = breakfast.split()[1]
# 			lunch = breakfast.next_sibling.next_sibling
# 			dinner = lunch.next_sibling.next_sibling
			
# 			###UGH but i'm going to have to deal with brunch and dinner so this for loop might not work.
# 			#i might just have to do the weekend days separately




database.updateDatabase("Frank Dining Hall", "monday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "thursday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "friday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "saturday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frank Dining Hall", "sunday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "monday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "thursday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "friday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "saturday", "0200-0600%0700-1200", "0")
database.updateDatabase("Frary Dining Hall", "sunday", "0200-1200", "0")














