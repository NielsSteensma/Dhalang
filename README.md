# Dhalang
[![Build Status](https://travis-ci.com/NielsSteensma/Dhalang.svg?token=XZgKAByw2KZjcrsCh8gW&branch=master)](https://travis-ci.com/NielsSteensma/Dhalang)


## Usage
__Get a PDF of a website url__  
`DhalangPDF.get_from_url("https://www.google.com")`  
Returns type of TempFile, make sure to provide the full url as shown above
  
  
__Get a PDF of a HTML string__  
`DhalangPDF.get_from_html("<html><head></head><body><h1>examplestring</h1></body></html>")`  
Returns type of TempFile.
