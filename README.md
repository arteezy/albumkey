[![Build Status](https://travis-ci.org/arteezy/richfork.svg?branch=master)](https://travis-ci.org/arteezy/richfork)
[![Code Climate](https://codeclimate.com/github/arteezy/richfork/badges/gpa.svg)](https://codeclimate.com/github/arteezy/richfork)
[![Test Coverage](https://codeclimate.com/github/arteezy/richfork/badges/coverage.svg)](https://codeclimate.com/github/arteezy/richfork/coverage)

# Pitchfork Analyst Tool

[richfork.ml](http://richfork.ml)

Rails web application for analysis of [Pitchfork](http://pitchfork.com) music album reviews.

## How it works

Web-crawler written with [Nokogiri](https://github.com/sparklemotion/nokogiri) gem parses reviews data directly from [pitchfork.com](http://pitchfork.com) and then stores it in MongoDB.

Rails application with [Mongoid](https://github.com/mongodb/mongoid) gem as ORM queries MongoDB for various user-defined parameters to allow more detailed reviews analysis than Pitchfork itself can provide. This app can filter reviews based on artist, label, rating, release date etc.

I plan to add some charts (d3.js) for visual analysis and maybe some kind of prediction of review ratings.
