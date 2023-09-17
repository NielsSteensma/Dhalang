module Dhalang
  # Allows consumers of this library to create PDFs with Puppeteer. 
  class PDF
    SCRIPT_PATH = File.expand_path('../js/pdf-generator.js', __FILE__).freeze
    private_constant :SCRIPT_PATH
    
    # Captures the full webpage under the given url as PDF.
    #
    # @param  [String] url      The url to get as PDF.
    # @param  [Hash]   options  User configurable options.
    #
    # @return [String] The PDF that was created as binary.
    def self.get_from_url(url, options = {})
      UrlUtils.validate(url)
      get(url, options)
    end

    # Captures the full HTML as PDF.
    # Useful when creating dynamic content, for example invoices.
    #
    # @param  [String]  html     The html to get as PDF.
    # @param  [Hash]    options  User configurable options.
    #
    # @return [String] The PDF that was created as binary.
    def self.get_from_html(html, options = {})
      html_file = FileUtils.create_temp_file("html", html)
      url = "file://" + html_file.path
      begin
          binary_pdf_content = get(url, options)
      ensure
        FileUtils.delete(html_file)
      end
      return binary_pdf_content
    end

    
    # Groups and executes the logic for creating a PDF of a webpage.
    #
    # @param  [Hash]    options  Set of options to use, passed by the user of this library.
    #
    # @return [String] The PDF that was created as binary.
    private_class_method def self.get(url, options)
      temp_file = FileUtils.create_temp_file("pdf")
      begin
        configuration = PuppeteerConfiguration.new(url, temp_file.path, "pdf", options)
        NodeScriptInvoker.execute_script(SCRIPT_PATH, configuration.json)
        binary_pdf_content = FileUtils.read_binary(temp_file.path)
      ensure
        FileUtils.delete(temp_file)
      end
      return binary_pdf_content
    end
  end
end
