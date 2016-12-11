# README

Backend for the live videos search platform. 
Ruby 2.3, Rails 5.

Instructions:

* Clone the code
* Install gem dependencies
```
bundle install
```
* Create a file config/application.yml and add your api keys in it in this format:
```
google_api_key: <your_api_key>
twitter_consumer_key: <your_twitter_consumer_key>
twitter_consumer_secret: <your_twitter_consumer_secret>
twitter_access_token_key: <your_twitter_access_token_key>
twitter_access_token_secret: <your_twitter_access_token_secret>
```
* Start the server 
```
rails s puma
```
* Current available method is 
```
GET /v1/videos/search?query=SEARCH_QUERY&platforms=PLATFORMS&num=PAGE_NUM
```
where ```platforms``` is a comma separated list of services (e.g: ```platforms=youtube,periscope```)
and ```num``` is an integer value

| Response      |                                                                  | 
| ------------- |:-----------------------------------------------------------------| 
| videos        | **list**<br />video(platform, title, thumbnail, streaming_url, browser_url) |
