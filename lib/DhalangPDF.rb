require "Dhalang/version"
require 'uri'
require 'tempfile'

class DhalangPDF
  PDF_GENERATOR_JS_PATH = File.expand_path('../js/pdfgenerator.js', __FILE__)
  PROJECT_PATH = Dir.pwd + '/node_modules/'

  def self.get_from_url(url)
    validate_url(url)
    temporary_pdf_save_file = create_temporary_pdf_file
    begin
      visit_page_with_puppeteer(url, temporary_pdf_save_file.path)
      binary_pdf_content = get_file_content_as_binary_string(temporary_pdf_save_file)
    ensure
      temporary_pdf_save_file.close unless temporary_pdf_save_file.closed?
      temporary_pdf_save_file.unlink
    end
    return binary_pdf_content
  end

  def self.get_from_html(html)
    html_file = create_temporary_html_file(html)
    temporary_pdf_save_file = create_temporary_pdf_file
    begin
      visit_page_with_puppeteer("file://" + html_file.path, temporary_pdf_save_file.path)
      binary_pdf_content = get_file_content_as_binary_string(temporary_pdf_save_file)
    ensure
      temporary_pdf_save_file.close unless temporary_pdf_save_file.closed?
      html_file.close unless html_file.closed?
      temporary_pdf_save_file.unlink
      html_file.unlink
    end
    return binary_pdf_content
  end

  private
  def self.validate_url(url)
    if(url !~ URI::DEFAULT_PARSER.regexp[:ABS_URI])
      raise URI::InvalidURIError, 'The given url was invalid, use format http://www.example.com'
    end
  end

  def self.create_temporary_pdf_file
    Tempfile.new("pdf")
  end

  ## Creates a temp .html file which can be browsed to by puppeteer for creating a pdf
  def self.create_temporary_html_file(content)
    html_file = Tempfile.new([ 'page', '.html' ])
    html_file.write(content)
    html_file.rewind
    return html_file
  end

  def self.visit_page_with_puppeteer(page_to_visit, path_to_save_pdf_to)
    system("node #{PDF_GENERATOR_JS_PATH} #{page_to_visit} #{Shellwords.escape(path_to_save_pdf_to)} #{Shellwords.escape(PROJECT_PATH)}")
  end

  def self.get_file_content_as_binary_string(file)
    IO.binread(file.path)
  end
end
