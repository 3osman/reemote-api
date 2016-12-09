# README

Backend for the live videos search platform. 
Ruby 2.3, Rails 5.

Instructions:

* Clone the code
* Install gem dependencies
```
bundle install
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

| Response      |                                                   | 
| ------------- |:-------------------------------------------------:| 
| videos        | **list** video(streaming_url, browser_url, title) |
