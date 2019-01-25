require "Dhalang/version"
require 'uri'
require 'tempfile'

class DhalangPDF
  HTML_TO_PDF_JS_PATH = File.expand_path('../js/pdfgeneration_fromhtml.js', __FILE__)
  URL_TO_PDF_JS_PATH = File.expand_path('../js/pdfgeneration_fromurl.js', __FILE__)


  def self.get_from_url(url)
    validate_url(url)
    temp_file = Tempfile.new("pdf")
    system("node #{URL_TO_PDF_JS_PATH} #{Shellwords.escape("http://www.google.com")} #{Shellwords.escape(temp_file.path)}")
    temp_file
  end

  def self.get_from_html(html)
    html_file = Tempfile.new("html")
    temp_file = Tempfile.new("pdf")
    begin
      html_file.write(html)
      html_file.rewind
      puts HTML_TO_PDF_JS_PATH
      system("node #{HTML_TO_PDF_JS_PATH} #{"file://" + html_file.path} #{Shellwords.escape(temp_file.path)}")
    ensure
      html_file.close
      html_file.unlink
    end
    temp_file
  end

  private
  def self.validate_url(url)
    if(url !~ URI::DEFAULT_PARSER.regexp[:ABS_URI])
      raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
    end
  end
end
