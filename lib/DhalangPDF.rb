require "Dhalang/version"
require 'uri'
require 'tempfile'

class DhalangPDF

  def self.get_from_url(url)
    validate_url(url)
    temp_file = Tempfile.new("pdf")
    system("node lib/js/pdfgeneration_fromurl.js #{Shellwords.escape("http://www.google.com")} #{Shellwords.escape(temp_file.path)}")
    temp_file
  end

  def self.get_from_html(html)
    html_file = Tempfile.new("html")
    temp_file = Tempfile.new("pdf")
    begin
      html_file.write(html)
      html_file.rewind
      system("node lib/js/pdfgeneration_fromhtml.js #{"file://" + html_file.path} #{Shellwords.escape(temp_file.path)}")
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
