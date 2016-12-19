# README

Backend for the live videos search platform. 
Ruby 2.3, Rails 5.

Instructions:

* Install gem dependencies
```
bundle install
```
* Create a file config/application.yml and add your api keys in it in this format:
```
google_api_key: <your_api_key>
twitch_client_id: <your_twitch_client_id>
```
* Start the server 
```
rails s puma
```
* Current available methods  
```
GET /v1/videos/search?query=SEARCH_QUERY&platforms=PLATFORMS
```
where ```platforms``` is a comma separated list of services (e.g: ```platforms=youtube,twitch,periscope```)

| Response      |                                                                  | 
| ------------- |:-----------------------------------------------------------------| 
| PLATFORM : videos        | **list**<br /> video(id, title, thumbnail) |

```
GET /v1/videos/info?id=VIDEO_ID&platform=PLATFORM
```

| Response      |                                                                  | 
| ------------- |:-----------------------------------------------------------------| 
| video        |  title, thumbnail, streaming_url, browser_url, viewers, hls_url (if available)  |

Use hls_url to directly stream the video (for example using [video.js](http://videojs.com/)
), and to not have to embed the service player in an iframe. Note that hls_url is not available for all services, so for each video, it would be a good idea to check if hls_url is returned, and use it if so. 
