# Dhalang [![Build Status](https://travis-ci.com/NielsSteensma/Dhalang.svg?token=XZgKAByw2KZjcrsCh8gW&branch=master)](https://travis-ci.com/NielsSteensma/Dhalang)

> Dhalang is a Ruby wrapper for Google's Puppeteer.


## Features
* Generate screenshots from pages.
* Generate PDFs from pages
* Generate PDFs from html ( external images/stylesheets supported )

## Prerequisites
NodeJS >= v7.6.0 

## Installation
Add this line to your application's Gemfile:

    gem 'dhalang'

And then execute:

    $ bundle update

Install puppeteer in your application's root directory:

    $ npm install puppeteer

## Usage
__Get a PDF of a website url__  
`Dhalang::PDF.get_from_url("https://www.google.com")`  
Returns type of TempFile, make sure to provide the full url as shown above
  
  
__Get a PDF of a HTML string__  
`Dhalang::PDF.get_from_html("<html><head></head><body><h1>examplestring</h1></body></html>")`  
Returns type of TempFile.
