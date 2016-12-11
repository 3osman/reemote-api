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
twith_client_id: <your_twitch_client_id>
```
* Start the server 
```
rails s puma
```
* Current available methods  
```
GET /v1/videos/search?query=SEARCH_QUERY&platforms=PLATFORMS
```
where ```platforms``` is a comma separated list of services (e.g: ```platforms=youtube,twitch```)

| Response      |                                                                  | 
| ------------- |:-----------------------------------------------------------------| 
| PLATFORM : videos        | **list**<br /> video(title, thumbnail, streaming_url, browser_url) |

```
GET /v1/videos/info?url=URL&platform=PLATFORM
```

| Response      |                                                                  | 
| ------------- |:-----------------------------------------------------------------| 
| info        | viewers |