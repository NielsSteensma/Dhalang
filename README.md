# Dhalang [![Build Status](https://travis-ci.com/NielsSteensma/Dhalang.svg?token=XZgKAByw2KZjcrsCh8gW&branch=master)](https://travis-ci.com/NielsSteensma/Dhalang)

> Dhalang is a Ruby wrapper for Google's Puppeteer.



## Features
* Generate PDFs from pages
* Generate PDFs from html ( external images/stylesheets supported )  
* Capture a screenshot of a webpage



## Installation
Add this line to your application's Gemfile:

    gem 'Dhalang'

And then execute:

    $ bundle update

Install puppeteer in your application's root directory:

    $ npm install puppeteer

<sub>NodeJS v10.18.1 or greater is required</sub>
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
  
  
  
## Custom PDF/screenshot options
To override the default options that are set by Dhalang you can pass as last argument a hash with the custom options you want to set.

For example to set custom margins for PDFs:

`Dhalang::PDF.get_from_url("https://www.google.com", {margin: { top: 100, right: 100, bottom: 100, left: 100}})
`

For example to only take a screenshot of the visible part of the page:
`Dhalang::Screenshot.get_from_url_as_png("https://www.google.com", {fullPage: false})
`

A list of all possible PDF options that can be set, can be found at: https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagepdfoptions

A list of all possible screenshot options that can be set, can be found at: https://github.com/puppeteer/puppeteer/blob/main/docs/api.md#pagescreenshotoptions




## Custom user options
You may want to change the way Dhalang interacts with Puppeteer in general. User options can be set by providing them in a hash as last argument to any calls you make to the library. Are you setting both custom PDF and user options? Then they should be passed as a single hash. 

For example to set a custom navigation timeout:
`Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com", {navigationTimeout: 20000})`  

Below table lists all possible configuration parameters that can be set:
| Key                | Description                                                                             | Default                         |
|--------------------|-----------------------------------------------------------------------------------------|---------------------------------|
| navigationTimeout  | Amount of milliseconds until Puppeteer while timeout when navigating to the given page  | 10000                           |
| navigationWaitForSelector | If set, Dhalang will wait for the specified selector to appear before creating the screenshot or PDF | None        |
| navigationWaitForXPath | If set, Dhalang will wait for the specified XPath to appear before creating the screenshot or PDF | None              |
| userAgent          | User agent to send with the request                                                     | Default Puppeteer one           |
| isHeadless         | Indicates if Chromium should be launched headless                                       | true                            |
| isAutoHeight       | When set to true the height of generated PDFs will be based on the scrollHeight property of the document body | false     |
| viewPort           | Custom viewport to use for the request                                                  | Default Puppeteer one           |
| httpAuthenticationCredentials | Custom HTTP authentication credentials to use for the request                | None                            |



## Examples of using Dhalang
To return a PDF from a Rails controller you can do the following:  
```ruby
def example_controller_method
  binary_pdf = Dhalang::PDF.get_from_url("https://www.google.com")  
  send_data(binary_pdf, filename: 'pdfofgoogle.pdf', type: 'application/pdf')  
end
```

To return a PNG from a Rails controller you can do the following:  
```ruby
def example_controller_method
  binary_png = Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")
  send_data(binary_png, filename: 'screenshotofgoogle.png', type: 'image/png')   
end
```

To return a JPEG from a Rails controller you can do the following:  
```ruby
def example_controller_method
  binary_jpeg = Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")
  send_data(binary_jpeg, filename: 'screenshotofgoogle.jpeg', type: 'image/jpeg')   
end
```
