# README
### Deployed to https://salty-tor-71342.herokuapp.com

#### Simple Rails App to display informations about a website given a valid URL.
##### Currently, it displays following informations about the given site

1. url
2. Does the body include my name? (Chris)
3. Does the website ust bootstrap?
4. What email addresses, if any, does the body contain?
5. Can I fetch this url?



##### Things that I would have done with more time:

* Better robots.txt parsing. Currently, it is very naive; Currently:
  * It just assumes that the path is allowed unless it's explicitly disallowed.
  * It does not take "User-Agent" into consideration
  
* Better UI?

* Integrate Sidekiq background job to process batch data?
