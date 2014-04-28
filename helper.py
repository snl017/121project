#helper.py

#for military function

#Created by Shannon Lubetich
#4/26/14

import re
import string

import time
import calendar

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

	#if is closed, just want to return closed string
	if n == 'Closed' :
		return n

	if '%' in n :
		return multHourMilitary(n)

	#make string from BeautifulSoup object
	encoded = n.encode('utf-8')
	#eliminate symbols from string
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

	if len(amPmArray) == 1 :
		amPmArray.append(amPmArray[0])

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


#helper function to call military on all bits of a multiple hour set, put them back together, and return
def multHourMilitary(n) :
	hourSets = n.split('%')
	resultString = ""
	for hourSet in hourSets :
		resultString+= military(hourSet)
		resultString += "%"
	#get rid of final % separator (because end of string has no mark after last hour set)
	resultString = resultString[:-1]
	return resultString


#helper function that gets system time since 1970, formats properly as number of minutes
#saves as float
#returns
def getTimeStamp():
	updatingTimeStamp = calendar.timegm(time.gmtime())
	return updatingTimeStamp
