module Dhalang
  # Allows consumers of this library to scrape webpages with Puppeteer.
  class Scraper
    PUPPETEER_SCRIPT_PATH = File.expand_path('../js/scraper.js', __FILE__).freeze
    private_constant :PUPPETEER_SCRIPT_PATH
    
    # Scrapes the content of the webpage under the given url.
    #
    # @param  [String] url      The url to get as PDF.
    # @param  [Hash]   options  User configurable options.
    #
    # @return [String] The PDF that was created as binary.
    def self.get_from_url(url, options = {})
      UrlUtils.validate(url)
      Puppeteer.scrape(url, PUPPETEER_SCRIPT_PATH, options)
    end
  end
end
