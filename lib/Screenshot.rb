require_relative "Dhalang/version"
require 'uri'
require 'tempfile'

module Dhalang
  class Screenshot
    SCREENSHOT_GENERATOR_JS_PATH = File.expand_path('../js/screenshot-generator.js', __FILE__)
    PROJECT_PATH = Dir.pwd + '/node_modules/'

    def self.get_from_url_as_jpeg(url)
      validate_url(url)
      get_image(url, :jpeg)
    end

    def self.get_from_url_as_png(url)
      validate_url(url)
      get_image(url, :png)
    end

    private
    def self.validate_url(url)
      if (url !~ URI::DEFAULT_PARSER.regexp[:ABS_URI])
        raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
      end
    end

    def self.create_temporary_screenshot_file
      Tempfile.new("png")
    end

    def self.get_image(url, type)
      temporary_screenshot_save_file = create_temporary_screenshot_file
      begin
        visit_page_with_puppeteer(url, temporary_screenshot_save_file.path, type)
        binary_image_content = get_file_content_as_binary_string(temporary_screenshot_save_file)
      ensure
        temporary_screenshot_save_file.close unless temporary_screenshot_save_file.closed?
        temporary_screenshot_save_file.unlink
      end
      return binary_image_content
    end

    def self.visit_page_with_puppeteer(page_to_visit, path_to_save_pdf_to, image_save_type)
      system("node #{SCREENSHOT_GENERATOR_JS_PATH} #{page_to_visit} #{Shellwords.escape(path_to_save_pdf_to)} #{Shellwords.escape(PROJECT_PATH)} #{Shellwords.escape(image_save_type)}")
    end

    def self.get_file_content_as_binary_string(file)
      IO.binread(file.path)
    end
  end
end
