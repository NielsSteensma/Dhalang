module Dhalang
    # Contains common logic for URL's. 
    class UrlUtils

        # Raises an error if the given URL cannot be used for navigation with Puppeteer.
        #
        # @param [String] url The url to validate
        def self.validate(url)
            parsed = URI.parse(url) # Raise URI::InvalidURIError on invalid URLs
            return true if parsed.absolute?

            raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
        end
    end
end
