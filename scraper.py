import urllib2
from urllib2 import urlopen
from bs4 import BeautifulSoup
import re
import string

#This is a testing section. We get the url and open it below.
# testURL = "http://flrc.pomona.edu/"
# html = urlopen(testURL).read()
# soup = BeautifulSoup(html)

#Then we look for the Hours of Operation Section
# test = soup.find_all('li', text = (re.compile("Tuesday.") or re.compile("Tuesday.")))

# for elt in test:
# 	print(str(elt))

#Wrapper Function - put hours into database-friendly military time
#Accepts a BeautifulSoup Object String
def military(n):
	encoded = n.encode('utf-8')
	formatted = encoded.translate(None, ' .')
	uniString = unicode(formatted, "UTF-8")
	uniString = uniString.replace(u"\u00A0", "")
	strFormat = str(uniString.encode('utf-8'))
	strFormat = strFormat.replace("midnight", "2400")
	strFormat = strFormat.replace("noon", "1200")
	return strFormat


	#TODO
	#Convert to military time based on if am or pm
	#also add zeroes.
	#if "midnight" in 


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

#find actual hours. Find monday by string search and get sibling for hours
mondayElt = eatshopHonnoldHours.find(text = (re.compile(".Mon."))).parent.next_sibling.next_sibling #first nextsibling gives whitespace
monHours = military(mondayElt.string)
print monHours


















