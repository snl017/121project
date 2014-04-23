import urllib2
from urllib2 import urlopen
from bs4 import BeautifulSoup
import re
import string
import database

#Created by Anna Turner and Shannon Lubetich
#4/15/2014



#This is a testing section. We get the url and open it below.
# testURL = "http://flrc.pomona.edu/"
# html = urlopen(testURL).read()
# soup = BeautifulSoup(html)

#Then we look for the Hours of Operation Section
# test = soup.find_all('li', text = (re.compile("Tuesday.") or re.compile("Tuesday.")))


#Function that goes through arrays of hours for each day and fills in missing days with the 
#assumption that those days are implied in a hyphen. I.e. a site might have mon-thurs: 8-10
#so we carry through the hours for Monday, tues, wed, thurs in the hours array.
"""TODO: deal with something says "closed", or if hours are simply just not listed for that 
day if it is closed"""
def fillInHoursDictionary(dictOfDaysToHours, arrayOfDayStrings) :
	currHourSet = ""
	for day in arrayOfDayStrings :
		if day in dictOfDaysToHours.keys()  :
			currHourSet = dictOfDaysToHours[day]
		else : 
			dictOfDaysToHours[day] = currHourSet

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

# Fill in the rest of the days
fillInHoursDictionary(dictOfDaysToHours, arrayOfDayStrings)

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

#Fill in rest of days
fillInHoursDictionary(dictOfDaysToHours, arrayOfDayStrings)

#now I need to know how to update the database on the server based on this info. hey update statements? 
#def updateDatabase(nameToUpdate,dayToUpdate,newHours,timeStamp):
databaseDayStrings = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Coop Fountain", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")










################################################################################
#FRANK AND FRARY#
#WORK IN PROGRESS#

poDiningURL = "http://www.pomona.edu/administration/dining/facilities-hours/hours.aspx"
poDiningHTML = urlopen(poDiningURL).read()
poDiningSoup = BeautifulSoup(poDiningHTML)



#FRANK
poDiningFrank = poDiningSoup.find('h2', text = (re.compile("Frank")))

#get mon-thurs section with by finding next next sibling (next sibling is white space)
poDiningFrankHoursWeek = poDiningFrank.next_sibling.next_sibling
poDiningFrankHoursWeekend = poDiningFrankHoursWeek.next_sibling.next_sibling

dictOfDaysToHours.clear()

#Doing Week
for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"

	#if the name of the day is explicitly here, then access hours
	desiredWeekSection = poDiningFrankHoursWeek.find(text = re.compile(dayRegex))
	if desiredWeekSection : 
		if "closed" in desiredWeekSection.lower() :
			dictOfDaysToHours[day] = "Closed"
		else: 
			#Military expects am and pm to show up in the time. Because the website for Frank and Frary
			#Doesn't include am and pm in their times we add it in here. We do this by splitting via regex
			#on the dash and reconstructing each string.

			#Breakfast
			breakfast = desiredWeekSection.parent.parent.next_sibling.next_sibling.next_sibling.next_sibling #first nextsibling gives whitespace
			breakfastTime = breakfast.split()[1]
			breakfastDeconstruct = breakfastTime.split('-')
			breakfastStart = breakfastDeconstruct[0] + 'am' + '-'
			breakfastEnd = breakfastDeconstruct[1] + 'pm'
			breakfastTime = breakfastStart + breakfastEnd
			breakfastTime = military(breakfastTime)

			#Lunch hours
			lunch = breakfast.next_sibling.next_sibling
			lunchTime = lunch.split()[1]
			lunchDeconstruct = lunchTime.split('-')
			lunchStart = lunchDeconstruct[0] + 'am' + '-'
			lunchEnd = lunchDeconstruct[1] + 'pm'
			lunchTime = lunchStart + lunchEnd
			lunchTime = military(lunchTime)

			#Dinner hours
			dinner = lunch.next_sibling.next_sibling
			dinnerTime = dinner.split()[1]
			dinnerDeconstruct = dinnerTime.split('-')
			dinnerStart = dinnerDeconstruct[0] + 'pm' + '-'
			dinnerEnd = dinnerDeconstruct[1] + 'pm'
			dinnerTime = dinnerStart + dinnerEnd
			dinnerTime = military(dinnerTime)

			#Concatenate and add to array
			frankHoursWeek = breakfastTime + '%' + lunchTime + '%' + dinnerTime
			dictOfDaysToHours[day] = frankHoursWeek

	#Do Weekend now
	desiredWeekendSection = poDiningFrankHoursWeekend.find(text = re.compile(dayRegex))
	if desiredWeekendSection :
		if "closed" in desiredWeekendSection.lower() :
			dictOfDaysToHours[day] = "Closed"
		else: 
			#Same thing as above with brunch and dinner
			
			#Brunch
			brunch = desiredWeekendSection.parent.parent.next_sibling.next_sibling.next_sibling.next_sibling #first nextsibling gives whitespace
			brunchTime = brunch.split()[1]
			brunchDeconstruct = brunchTime.split('-')
			brunchStart = brunchDeconstruct[0] + 'am' + '-'
			brunchEnd = brunchDeconstruct[1] + 'pm'
			brunchTime = brunchStart + brunchEnd
			brunchTime = military(brunchTime)

			#Dinner
			dinner = brunch.next_sibling.next_sibling
			dinnerTime = dinner.split()[1]
			dinnerDeconstruct = dinnerTime.split('-')
			dinnerStart = dinnerDeconstruct[0] + 'pm' + '-'
			dinnerEnd = dinnerDeconstruct[1] + 'pm'
			dinnerTime = dinnerStart + dinnerEnd
			dinnerTime = military(dinnerTime)

			#Concatenate and add to array
			frankHoursWeekend = brunchTime + '%' + dinnerTime
			dictOfDaysToHours[day] = frankHoursWeekend

#Fill in rest of days and hours array
fillInHoursDictionary(dictOfDaysToHours, arrayOfDayStrings)
#Update Database
for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Frank Dining Hall", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")






#FRARY
poDiningFrary = poDiningSoup.find('h2', text = (re.compile("Frary")))

#get mon-thurs section with by finding next next sibling (next sibling is white space)
poDiningFraryHoursWeek = poDiningFrary.next_sibling.next_sibling
poDiningFraryHoursWeekend = poDiningFraryHoursWeek.next_sibling.next_sibling
poDiningFraryHoursSnack = poDiningFraryHoursWeekend.next_sibling.next_sibling.next_sibling.next_sibling

dictOfDaysToHours.clear()

#Doing Week
for day in arrayOfDayStrings : 
	dayRegex = ".*" + day + ".*"

	#if the name of the day is explicitly here, then access hours
	desiredWeekSection = poDiningFraryHoursWeek.find(text = re.compile(dayRegex))
	if desiredWeekSection : 
		if "closed" in desiredWeekSection.lower() :
			dictOfDaysToHours[day] = "Closed"
		else: 
			#Military expects am and pm to show up in the time. Because the website for Frary and Frary
			#Doesn't include am and pm in their times we add it in here. We do this by splitting via regex
			#on the dash and reconstructing each string.

			#Breakfast
			breakfast = desiredWeekSection.parent.parent.next_sibling.next_sibling#first nextsibling gives whitespace
			breakfastTime = breakfast.split()[1]
			breakfastDeconstruct = breakfastTime.split('-')
			breakfastStart = breakfastDeconstruct[0] + 'am' + '-'
			breakfastEnd = breakfastDeconstruct[1] + 'am'
			breakfastTime = breakfastStart + breakfastEnd
			breakfastTime = military(breakfastTime)

			#Lunch hours
			lunch = breakfast.next_sibling.next_sibling
			lunchTime = lunch.split()[1]
			lunchDeconstruct = lunchTime.split('-')
			lunchStart = lunchDeconstruct[0] + 'am' + '-'
			lunchEnd = lunchDeconstruct[1] + 'pm'
			lunchTime = lunchStart + lunchEnd
			lunchTime = military(lunchTime)

			#Dinner hours
			dinner = lunch.next_sibling.next_sibling
			dinnerTime = dinner.split()[1]
			dinnerDeconstruct = dinnerTime.split('-')
			dinnerStart = dinnerDeconstruct[0] + 'pm' + '-'
			dinnerEnd = dinnerDeconstruct[1] + 'pm'
			dinnerTime = dinnerStart + dinnerEnd
			dinnerTime = military(dinnerTime)

			#Concatenate and add to array
			fraryHoursWeek = breakfastTime + '%' + lunchTime + '%' + dinnerTime
			dictOfDaysToHours[day] = fraryHoursWeek

	#Do Weekend now
	desiredWeekendSection = poDiningFraryHoursWeekend.find(text = re.compile(dayRegex))
	if desiredWeekendSection :
		if "closed" in desiredWeekendSection.lower() :
			dictOfDaysToHours[day] = "Closed"
		else: 
			#Same thing as above with continental bfast, brunch and dinner
			cBreakfast = desiredWeekendSection.parent.parent.next_sibling.next_sibling #first nextsibling gives whitespace
			cBreakfastTime = cBreakfast.split()[2]
			cBreakfastDeconstruct = cBreakfastTime.split('-')
			cBreakfastStart = cBreakfastDeconstruct[0] + 'am' + '-'
			cBreakfastEnd = cBreakfastDeconstruct[1] + 'pm'
			cBreakfastTime = cBreakfastStart + cBreakfastEnd
			cBreakfastTime = military(cBreakfastTime)

			#Brunch
			brunch = cBreakfast.next_sibling.next_sibling
			brunchTime = brunch.split()[1]
			brunchDeconstruct = brunchTime.split('-')
			brunchStart = brunchDeconstruct[0] + 'am' + '-'
			brunchEnd = brunchDeconstruct[1] + 'pm'
			brunchTime = brunchStart + brunchEnd
			brunchTime = military(brunchTime)

			#Dinner
			dinner = brunch.next_sibling.next_sibling
			dinnerTime = dinner.split()[1]
			dinnerDeconstruct = dinnerTime.split('-')
			dinnerStart = dinnerDeconstruct[0] + 'pm' + '-'
			dinnerEnd = dinnerDeconstruct[1] + 'pm'
			dinnerTime = dinnerStart + dinnerEnd
			dinnerTime = military(dinnerTime)

			#Concatenate and add to array
			fraryHoursWeekend = cBreakfastTime + '%' + brunchTime + '%' + dinnerTime
			dictOfDaysToHours[day] = fraryHoursWeekend
			#print dictOfDaysToHours

#Doing Frary Snack Separately
#Snack
snack = poDiningFraryHoursSnack.find("strong").next_sibling
snackTime = snack.split()[0]
snackDeconstruct = snackTime.split('-')
snackStart = snackDeconstruct[0] + 'pm' + '-'
snackEnd = snackDeconstruct[0].replace(',','') + 'pm'
snackTime = snackStart + snackEnd
snackTime = military(snackTime)


#Fill in rest of days and hours array
fillInHoursDictionary(dictOfDaysToHours, arrayOfDayStrings)

#Tack on snack hours
dictOfDaysToHours["Sun"] = dictOfDaysToHours["Sun"] + '%' + str(snackTime)
dictOfDaysToHours["Mon"] = dictOfDaysToHours["Mon"] + '%' + str(snackTime)
dictOfDaysToHours["Tues"] = dictOfDaysToHours["Tues"] + '%' + str(snackTime)
dictOfDaysToHours["Wed"] = dictOfDaysToHours["Wed"] + '%' + str(snackTime)

#Update Database
for i in range(len(arrayOfDayStrings)) :
	database.updateDatabase("Frary Dining Hall", databaseDayStrings[i], dictOfDaysToHours[arrayOfDayStrings[i]], "0")


 




			





# database.updateDatabase("Frank Dining Hall", "monday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "thursday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "friday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "saturday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frank Dining Hall", "sunday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "monday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "tuesday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "wednesday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "thursday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "friday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "saturday", "0200-0600%0700-1200", "0")
# database.updateDatabase("Frary Dining Hall", "sunday", "0200-1200", "0")














