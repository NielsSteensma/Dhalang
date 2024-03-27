module Dhalang
  # Groups Puppeteer and Dhalang configuration.
  class Configuration
    NODE_MODULES_PATH = Dir.pwd + '/node_modules/'.freeze
    USER_OPTIONS = {
      navigationTimeout: 10000,
      printToPDFTimeout: 0, # unlimited
      navigationWaitUntil: 'load',
      navigationWaitForSelector: '',
      navigationWaitForXPath: '',
      userAgent: '',
      isHeadless: true,
      viewPort: '',
      httpAuthenticationCredentials: '',
      isAutoHeight: false,
      chromeOptions: []
    }.freeze
    DEFAULT_PDF_OPTIONS = {
      scale: 1,
      displayHeaderFooter: false,
      headerTemplate: '',
      footerTemplate: '',
      headerTemplateFile: '',
      footerTemplateFile: '',
      printBackground: true,
      landscape: false,
      pageRanges: '',
      format: 'A4',
      width: '',
      height: '',
      margin: { top: 36, right: 36, bottom: 20, left: 36 },
      preferCSSPageSize: true,
      omitBackground: false
    }.freeze
    DEFAULT_SCREENSHOT_OPTIONS = {
      fullPage: true,
      clip: nil,
      omitBackground: false
    }.freeze
    DEFAULT_JPEG_OPTIONS = {
      quality: 100
    }.freeze

    private_constant :NODE_MODULES_PATH
    private_constant :USER_OPTIONS
    private_constant :DEFAULT_PDF_OPTIONS
    private_constant :DEFAULT_SCREENSHOT_OPTIONS
    private_constant :DEFAULT_JPEG_OPTIONS

    private attr_accessor :page_url
    private attr_accessor :temp_file_path
    private attr_accessor :temp_file_extension
    private attr_accessor :user_options
    private attr_accessor :pdf_options
    private attr_accessor :screenshot_options
    private attr_accessor :jpeg_options

    # @param [Hash]   custom_options        Changes that override default.
    # @param [String] page_url              Url for Puppeteer to visit.
    # @param [String] temp_file_path        Absolute path of temp file to use for writing script results.
    #                                       Can be nil for scripts using stdout.
    # @param [String] temp_file_extension   Extension of temp file. Can be nil for scripts using stdout.
    def initialize(custom_options, page_url, temp_file_path = nil, temp_file_extension = nil)
      self.page_url = page_url
      self.temp_file_path = temp_file_path
      self.temp_file_extension = temp_file_extension
      self.user_options = USER_OPTIONS.map { |key, default_value| [key, custom_options.fetch(key, default_value)] }
      self.pdf_options = DEFAULT_PDF_OPTIONS.map { |key, default_value| [key, custom_options.fetch(key, default_value)] }
      self.screenshot_options = DEFAULT_SCREENSHOT_OPTIONS.map { |key, default_value| [key, custom_options.fetch(key, default_value)] }
      self.jpeg_options = DEFAULT_JPEG_OPTIONS.map { |key, default_value| [key, custom_options.fetch(key, default_value)] }
    end

    # Returns configuration as JSON string.
    def json
      return {
        webPageUrl: page_url,
        tempFilePath: temp_file_path,
        puppeteerPath: NODE_MODULES_PATH,
        imageType: temp_file_extension,
        userOptions: user_options.to_h,
        pdfOptions: pdf_options.to_h,
        screenshotOptions: screenshot_options.to_h,
        jpegOptions: jpeg_options.to_h
      }.to_json
    end
  end
end