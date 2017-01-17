[![Build Status](https://travis-ci.org/arteezy/albumkey.svg?branch=master)](https://travis-ci.org/arteezy/albumkey)
[![Code Maintainability](https://api.codeclimate.com/v1/badges/67d6970f19d9fd440be0/maintainability)](https://codeclimate.com/github/arteezy/albumkey/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/67d6970f19d9fd440be0/test_coverage)](https://codeclimate.com/github/arteezy/albumkey/test_coverage)

# Pitchfork Analyst Tool

[albumkey.com](http://albumkey.com)

Rails web application for analysis of [Pitchfork](http://pitchfork.com) music album reviews.

## How it works

Web-crawler written with [Nokogiri](https://github.com/sparklemotion/nokogiri) gem parses reviews data directly from [pitchfork.com](http://pitchfork.com) and then stores it in MongoDB.

Rails application with [Mongoid](https://github.com/mongodb/mongoid) gem as ORM queries MongoDB for various user-defined parameters to allow more detailed reviews analysis than Pitchfork itself can provide. This app can filter reviews based on artist, label, rating, release date etc.

I plan to add some charts (d3.js) for visual analysis and maybe some kind of prediction of review ratings.
