# Dhalang [![Build Status](https://travis-ci.com/NielsSteensma/Dhalang.svg?token=XZgKAByw2KZjcrsCh8gW&branch=master)](https://travis-ci.com/NielsSteensma/Dhalang)

> Dhalang is a Ruby wrapper for Google's Puppeteer.


## Features
* Generate PDFs from pages
* Generate PDFs from html ( external images/stylesheets supported )  
  
More will come.

## Installation
Add this line to your application's Gemfile:

    gem 'dhalang'

And then execute:

    $ bundle update

Install puppeteer in your application's root directory:

    $ npm install puppeteer

<sub>NodeJS v7.6.0 or greater is required</sub>
## Usage
__Get a PDF of a website url__  
`Dhalang::PDF.get_from_url("https://www.google.com")`  
It is important to pass the complete url, leaving out https://, http:// or www. will result in an error.
  
__Get a PDF of a HTML string__  
`Dhalang::PDF.get_from_html("<html><head></head><body><h1>examplestring</h1></body></html>")`  

Both methods return a string containing the PDF in binary.   
  
When you for example want to return the PDF from a Rails API you can do the following in a controller:  
```
def example_controller_method  
    binary_pdf = Dhalang::PDF.get_from_url("https://www.google.com")  
    send_data(binary_pdf, filename: 'pdfofgoogle.pdf', type: 'application/pdf')  
end
```
