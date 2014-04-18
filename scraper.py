import urllib2
from urllib2 import urlopen
from bs4 import BeautifulSoup
import re

#This is a testing section. We get the url and open it below.
testURL = "http://flrc.pomona.edu/"
html = urlopen(testURL).read()
soup = BeautifulSoup(html)

#Then we look for the Hours of Operation Section
test = soup.find_all('li', text = (re.compile("Tuesday.") or re.compile("Tuesday.")))

for elt in test:
	print(str(elt))


#print(soup.prettify())