module Dhalang
    # Contains common logic for URL's. 
    class UrlUtils

        # Raises an error if the given URL cannot be used for navigation with Puppeteer.
        #
        # @param [String] url The url to validate
        def self.validate(url)
            if (url !~ URI::DEFAULT_PARSER.regexp[:ABS_URI])
                raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
            end
        end
    end
end