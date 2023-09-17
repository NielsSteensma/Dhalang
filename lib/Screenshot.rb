module Dhalang
  # Allows consumers of this library to take screenshots with Puppeteer. 
  class Screenshot
    SCRIPT_PATH = File.expand_path('../js/screenshot-generator.js', __FILE__).freeze
    IMAGE_TYPES = [:jpeg, :png, :webp].freeze
    private_constant :SCRIPT_PATH
    private_constant :IMAGE_TYPES
    
    # <b>DEPRECATED:</b> Please use `get_from_url(url, :jpeg)` instead.
    # Captures a full JPEG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [Hash]   options    User configurable options.
    #
    # @return [String] the screenshot that was taken as binary.
    def self.get_from_url_as_jpeg(url, options = {})
      warn "[DEPRECATION] `get_from_url_as_jpeg` is deprecated.  Use `get_from_url(url, :jpeg)` instead."
      get_from_url(url, :jpeg, options)
    end

    # <b>DEPRECATED:</b> Please use `get_from_url(url, :png)` instead.
    # Captures a full PNG screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [Hash]   options    User configurable options.
    #
    # @return [String] The screenshot that was taken as binary.
    def self.get_from_url_as_png(url, options = {})
      warn "[DEPRECATION] `get_from_url_as_png` is deprecated.  Use `get_from_url(url, :png)` instead."
      get_from_url(url, :png, options)
    end

    # Captures a screenshot of the webpage under the given url.
    #
    # @param  [String] url        The url to take a screenshot of.
    # @param  [String] image_type The image type (JPEG/PNG/WEBP) to use for storing the screenshot.
    # @param  [Hash]   options    User configurable options.
    #
    # @return [String] The screenshot that was taken as binary.
    def self.get_from_url(url, image_type, options = {})
      UrlUtils.validate(url)
      validate_image_type(image_type)
      validate_options(options)

      temp_file = FileUtils.create_temp_file(image_type)
      configuration = PuppeteerConfiguration.new(url, temp_file.path, image_type, options)
      begin
        NodeScriptInvoker.execute_script(SCRIPT_PATH, configuration.json)
        binary_image_content = FileUtils.read_binary(temp_file.path)
      ensure
        FileUtils.delete(temp_file)
      end
      return binary_image_content
    end

    # Raises an error if the given image type is not supported.
    #
    # @param [String] image_type The image_type to validate
    private_class_method def self.validate_image_type(image_type)
      if !IMAGE_TYPES.include? image_type.downcase
        raise DhalangError, 'Unsupported image type' 
      end
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
