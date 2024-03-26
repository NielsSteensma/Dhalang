module Dhalang
  # Provides functionality for scraping webpages.
  class Scraper
    SCRIPT_PATH = File.expand_path('../js/scraper.js', __FILE__).freeze
    private_constant :SCRIPT_PATH
    
    # Scrapes content under the given url.
    #
    # @param  [String] url      Url to scrape.
    # @param  [Hash]   options  User configurable options.
    #
    # @return [String] Scraped HTML content.
    def self.scrape(url, options = {})
      UrlUtils.validate(url)
      configuration = Configuration.new(url, options)
      return NodeScriptInvoker.execute_script_and_read_stdout(SCRIPT_PATH, configuration.json)
    end
  end
end
