module Dhalang
  # Allows consumers of this library to scrape webpages with Puppeteer.
  class Scraper
    SCRIPT_PATH = File.expand_path('../js/scraper.js', __FILE__).freeze
    private_constant :SCRIPT_PATH
    
    # Scrapes the content of the webpage under the given url.
    #
    # @param  [String] url      The url to get as PDF.
    # @param  [Hash]   options  User configurable options.
    #
    # @return [String] The PDF that was created as binary.
    def self.get_from_url(url, options = {})
      UrlUtils.validate(url)
      puppeteer = PuppeteerConfiguration.new(url, options)
      return NodeScriptInvoker.execute_script_and_read_stdout(SCRIPT_PATH, puppeteer.json)
    end
  end
end
