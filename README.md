# Dhalang [![Build Status](https://travis-ci.com/NielsSteensma/Dhalang.svg?token=XZgKAByw2KZjcrsCh8gW&branch=master)](https://travis-ci.com/NielsSteensma/Dhalang)

> Dhalang is a Ruby wrapper for Google's Puppeteer.


## Features
* Generate PDFs from pages
* Generate PDFs from html ( external images/stylesheets supported )  
* Capture a screenshots of a webpage

## Installation
Add this line to your application's Gemfile:

    gem 'Dhalang'

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

__Get a PNG screenshot of a website__  
`Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")`  

__Get a JPEG screenshot of a website__  
`Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")`  

All methods return a string containing the PDF or JPEG/PNG in binary.   
  
To return the PDF from a Rails controller you can do the following:  
```
def example_controller_method  
    binary_pdf = Dhalang::PDF.get_from_url("https://www.google.com")  
    send_data(binary_pdf, filename: 'pdfofgoogle.pdf', type: 'application/pdf')  
end
```

To return the PNG from a Rails controller you can do the following:  
```
def example_controller_method  
    binary_png = Dhalang::Screenshot.get_from_url_as_png("https://www.google.nl")
    send_data(binary_png, filename: 'screenshotofgoogle.png', type: 'image/png')   
end
```

To return the JPEG from a Rails controller you can do the following:  
```
def example_controller_method  
    binary_jpeg = Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.nl")
    send_data(binary_jpeg, filename: 'screenshotofgoogle.jpeg', type: 'image/jpeg')   
end
```
