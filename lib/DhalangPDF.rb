require "Dhalang/version"
require 'uri'
require 'tempfile'

class DhalangPDF
  PDF_GENERATOR_JS_PATH = File.expand_path('../js/pdfgenerator.js', __FILE__)
  PROJECT_PATH = Dir.pwd + '/node_modules/'

  def self.get_from_url(url)
    validate_url(url)
    temp_file = Tempfile.new("pdf")
    system("node #{PDF_GENERATOR_JS_PATH} #{url} #{Shellwords.escape(temp_file.path)} #{Shellwords.escape(PROJECT_PATH)}")
    temp_file
  end

  def self.get_from_html(html)
    html_file = Tempfile.new("html")
    temp_file = Tempfile.new("pdf")
    begin
      html_file.write(html)
      html_file.rewind
      system("node #{PDF_GENERATOR_JS_PATH} #{"file://" + html_file.path} #{Shellwords.escape(temp_file.path)} #{Shellwords.escape(PROJECT_PATH)}")
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
