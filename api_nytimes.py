from nytimesarticle import articleAPI
import requests
import lxml.html as lh
import re
import sys 
import csv

def searchTopic(topic):
	f = open('secret', 'r')
	for line in f:
		if line.find('NYTIMES_ARTICLE') != -1:
			a,key = line.split('=')

	key = key.replace('\n','')
	api = articleAPI(key)
	topic = topic
	headline = topic
	sources = ['Reuters', 'AP', 'The New York Times']
	beg_date = 20140101
	pages = str(3)


	articles = api.search(q = topic, fq = {'headline':topic, 'source':sources}, 
		fl = ['web_url'], begin_date = beg_date, page = pages)
	articles_content = []
	output = []
	for url in articles['response']['docs']:
		if url['web_url'].find('video') == -1:
			page = requests.get(url['web_url'])
			doc = lh.fromstring(page.content)
			text = doc.xpath('//p[@itemprop="articleBody"]')
			article = str()
			for par in text:
				paragraph = par.text_content()
				article += paragraph
			articles_content.append(article)
	for count, art in enumerate(articles_content):
		regex = re.compile('[^a-zA-Z]')
		articles_content[count] = regex.sub(' ', art)
	with open('%s data.csv' % topic, 'wb') as output_file:
		wr = csv.writer(output_file, quoting=csv.QUOTE_ALL)
		wr.writerow(articles_content)
	print articles_content






if __name__ == '__main__':
	str_input = ''
	for x in range(len(sys.argv) - 1):
		str_input = str_input + sys.argv[x + 1] + ' '
	searchTopic(sys.argv[1:])

