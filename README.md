# Pitchfork Analyst Tool
Rails web application for analysis of [Pitchfork](http://pitchfork.com) reviews.

## How it works 

Web-crawler written with Nokogiri gem parses reviews data directly from [pitchfork.com](http://pitchfork.com) and then stores it in MongoDB.

Rails application with Mongoid gem as ORM queries MongoDB for various user-defined parameters to allow more detailed reviews analysis than Pitchfork itself can provide. This app can filter reviews based on artist, label, score, release date etc.

I plan to add some charts (d3.js) for visual analysis and maybe some kind of prediction of review scores.