# Dhalang [![Build](https://github.com/NielsSteensma/Dhalang/actions/workflows/build.yml/badge.svg)](https://github.com/NielsSteensma/Dhalang/actions/workflows/build.yml) [![Gem Version](https://badge.fury.io/rb/Dhalang.svg)](https://badge.fury.io/rb/Dhalang)

> Dhalang is a Ruby wrapper for Google's Puppeteer.



## Features
* Generate PDFs from webpages
* Generate PDFs from HTML ( external images/stylesheets supported )  
* Capture screenshots from webpages
* Scrape HTML from webpages


## Prerequisites
* Node ≥ 18
* Puppeteer ≥ 22
* Unix shell ( Dhalang will not work on Windows shells )
  
## Installation
Add this line to your application's Gemfile:

    gem 'Dhalang'

And then execute:

    $ bundle update

Install puppeteer or puppeteer-core in your application's root directory:

    $ npm install puppeteer 
    or
    $ npm install puppeteer-core

## Usage
__PDF of a website url__  
```ruby
Dhalang::PDF.get_from_url("https://www.google.com")
```
It is important to pass the complete url, leaving out https://, http:// or www. will result in an error.

__PDF of a HTML string__  
```ruby
Dhalang::PDF.get_from_html("<html><head></head><body><h1>examplestring</h1></body></html>") 
```

__PNG screenshot of a website__  
```ruby
Dhalang::Screenshot.get_from_url("https://www.google.com", :png)  
```

__JPEG screenshot of a website__  
```ruby
Dhalang::Screenshot.get_from_url("https://www.google.com", :jpeg)  
```

__WEBP screenshot of a website__  
```ruby
Dhalang::Screenshot.get_from_url("https://www.google.com", :webp)  
```

__HTML of a website__
```ruby
Dhalang::Scraper.html("https://www.google.com")  
```

Above methods either return a string containing the PDF/JPEG/PNG/WEBP in binary or the scraped HTML.   
  
  
  
## Custom options
To override the default options that are set by Dhalang you can pass as last argument a hash with the custom options you want to set.

For example to set custom margins for PDFs:
```ruby
Dhalang::PDF.get_from_url("https://www.google.com", {margin: { top: 100, right: 100, bottom: 100, left: 100}})
```

For example to only take a screenshot of the visible part of the page:
```ruby
Dhalang::Screenshot.get_from_url("https://www.google.com", :webp, {fullPage: false})
```

A list of all possible PDF options that can be set, can be found at: https://github.com/puppeteer/puppeteer/blob/main/docs/api/puppeteer.pdfoptions.md

A list of all possible screenshot options that can be set, can be found at: https://github.com/puppeteer/puppeteer/blob/main/docs/api/puppeteer.screenshotoptions.md
> The default Puppeteer options contain the options `headerTemplate` and `footerTemplate`. Puppeteer expects these to be HTML strings. By default, the Dhalang
> gem passes all options as arguments in a `node ...` shell command.  In case the HTML strings are too long they might surpass the maximum
> argument length of the host.  For example, on Linux the `MAX_ARG_LEN` is 128kB. Therefore, you can also pass the headers and footers as file path using the
> options `headerTemplateFile` and `footerTemplateFile`. These non-Puppeteer-options will be used to populate the Puppeteer-options `headerTemplate` and `footerTemplate`.
>
> For example: `Dhalang::PDF.get_from_url("https://www.google.com", {headerTemplateFile: '/tmp/header.html', footerTemplateFile: '/tmp/footer.html'})`

Below table lists more configuration parameters that can be set:
| Key                | Description                                                                             | Default                         |
|--------------------|-----------------------------------------------------------------------------------------|---------------------------------|
| browserWebsocketUrl | Websocket url of remote chromium browser to use                                        | None                            |
| navigationTimeout  | Amount of milliseconds until Puppeteer while timeout when navigating to the given page  | 10000                           |
| printToPDFTimeout  | Amount of milliseconds until Puppeteer while timeout when calling Page.printToPDF       | 0 (unlimited)                   |
| navigationWaitForSelector | If set, Dhalang will wait for the specified selector to appear before creating the screenshot or PDF | None        |
| navigationWaitForXPath | If set, Dhalang will wait for the specified XPath to appear before creating the screenshot or PDF | None              |
| userAgent          | User agent to send with the request                                                     | Default Puppeteer one           |
| isHeadless         | Indicates if Chromium should be launched headless                                       | true                            |
| isAutoHeight       | When set to true the height of generated PDFs will be based on the scrollHeight property of the document body | false     |
| viewPort           | Custom viewport to use for the request                                                  | Default Puppeteer one           |
| httpAuthenticationCredentials | Custom HTTP authentication credentials to use for the request                | None                            |
| chromeOptions  | A array of [options](https://peter.sh/experiments/chromium-command-line-switches/) that can be passed to puppeteer in addition to the mandatory `['--no-sandbox', '--disable-setuid-sandbox']` | []                           |


## Examples of using Dhalang
To return a PDF from a Rails controller you can do the following:  
```ruby
def example_controller_method
  binary_pdf = Dhalang::PDF.get_from_url("https://www.google.com")  
  send_data(binary_pdf, filename: 'pdfofgoogle.pdf', type: 'application/pdf')  
end
```

To return a screenshot from a Rails controller you can do the following:  
```ruby
def example_controller_method
  binary_png = Dhalang::Screenshot.get_from_url("https://www.google.com", :png)
  send_data(binary_png, filename: 'screenshotofgoogle.png', type: 'image/png')   
end
```
