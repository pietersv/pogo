#!/usr/bin/env python
import twitter
import json

consumer_key = 'GO2w8H7fsU6prfRIc6vG49aec'
consumer_secret = 'PLB969zdMsPll3lzUpBG8UIC6a99JXrSqxUP8fWJ8lUgjvzThV'
access_token_key = '3091565165-1LOxNVORx75ZnfgyZNUdq7OIzsHzo8OLZ8QaP5q'
access_token_secret = 'iOlmQoEJti1I5KiFH9MGDCt5mnJrClzEsEBZSdCcMPpvs'


auth = twitter.oauth.OAuth(access_token_key, access_token_secret, consumer_key, consumer_secret)
twitter_api = twitter.Twitter(auth=auth)
print twitter_api

q = '#iPhone'
count = 1500
language = 'en'
search_results = twitter_api.search.tweets(q=q, lang = language, count=count)

statuses = search_results['statuses']

status_texts = [status['text'] for status in statuses]
# status_texts = [unicode(stat).encode('utf-8') for stat in status_texts]
# screen_names = [user_mention['screen_name'] for status in statuses for user_mention in status['entities']['user_mentions']]
# hashtags = [hashtag['text'] for status in statuses for hashtag in status['entities']['hashtags']]

words = [w for t in status_texts for w in t.split()]

print json.dumps(status_texts[0:100], indent=1)
# print json.dumps(screen_names[0:5], indent=1) 
# print json.dumps(hashtags[0:100], indent=1)
# print json.dumps(words[0:5], indent=1)
