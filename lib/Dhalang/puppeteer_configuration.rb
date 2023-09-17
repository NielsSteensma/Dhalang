module Dhalang
    # Contains logic for configuring Puppeteer.
    class PuppeteerConfiguration
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

        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        # @param [Hash]   options               Set of options to use, configurable by the user.
        def initialize(page_url, temp_file_path = nil, temp_file_extension = nil, options)
            self.page_url = page_url
            self.temp_file_path = temp_file_path
            self.temp_file_extension = temp_file_extension
            self.user_options = USER_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value]}
            self.pdf_options = DEFAULT_PDF_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }
            self.screenshot_options = DEFAULT_SCREENSHOT_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }
            self.jpeg_options = DEFAULT_JPEG_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }
        end

        # Returns a JSON string of the configuration.
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
