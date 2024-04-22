module Dhalang
  # Provides functionality for scraping webpages.
  class Scraper
    SCRIPT_PATH = File.expand_path('../js/html-scraper.js', __FILE__).freeze
    private_constant :SCRIPT_PATH
    
    # Scrapes full HTML content under given url.
    #
    # @param  [String] url      Url to scrape.
    # @param  [Hash]   options  User configurable options.
    #
    # @return [String] Scraped HTML content.
    def self.html(url, options = {})
      temp_file = FileUtils.create_temp_file("html")
      begin
        configuration = Configuration.new(options, url, temp_file.path, "html")
        NodeScriptInvoker.execute_script(SCRIPT_PATH, configuration)
        html = IO.read(temp_file.path)
      ensure
        FileUtils.delete(temp_file)
      end
      return html
    end
  end
end
