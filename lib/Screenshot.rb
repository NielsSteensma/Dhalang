module Dhalang
  # Allows consumers of this library to take screenshots with Puppeteer. 
  class Screenshot
    PUPPETEER_SCRIPT_PATH = File.expand_path('../js/screenshot-generator.js', __FILE__).freeze
    private_constant :PUPPETEER_SCRIPT_PATH
    
    # Captures a full JPEG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [Hash]   options    User configurable options.
    #
    # @return [String] the screenshot that was taken as binary.
    def self.get_from_url_as_jpeg(url, options = {})
      get(url, "jpeg", options)
    end

    # Captures a full PNG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [Hash]   options    User configurable options.
    #
    # @return [String] The screenshot that was taken as binary.
    def self.get_from_url_as_png(url, options = {})
      get(url, "png", options)
    end
    
    # Groups and executes the logic for taking a screenhot of a webpage.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [String] image_type The image type to use for storing the screenshot.
    # @param  [Hash]   options    Set of options to use, passed by the user of this library.
    #
    # @return [String] The screenshot that was taken as binary.
    private_class_method def self.get(url, image_type, options)
      UrlUtils.validate(url)
      validate_options(options)
      temp_file = FileUtils.create_temp_file(image_type)
      begin
        Puppeteer.visit(url, PUPPETEER_SCRIPT_PATH, temp_file.path, image_type, options)
        binary_image_content = FileUtils.read_binary(temp_file.path)
      ensure
        FileUtils.delete(temp_file)
      end
      return binary_image_content
    end

    # Raises an error if the given options might conflict with the Puppeteer configuration.
    #
    # @param [Hash] options The options to validate
    private_class_method def self.validate_options(options)
      symbolized_options = options.transform_keys(&:to_sym)
      if symbolized_options.has_key?(:type)
        raise DhalangError, 'Invalid option set: "type"'
      end
    end
  end
end
