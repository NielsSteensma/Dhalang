require 'rspec'
require 'Dhalang'
require 'pdf/reader'

describe '#get_from_url' do
  context 'url without specified protocol' do
    it 'should raise InvalidURIError' do
      expect { Dhalang::PDF.get_from_url("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'returns a pdf containing the web page' do
      pdf_binary_content = Dhalang::PDF.get_from_url("https://www.google.com")
      pdf_reader = PDF::Reader.new(create_pdf_file(pdf_binary_content).path)
      expect(pdf_reader.page(1).to_s.include?("Google")).to be true
    end

    it 'raises DhalangError on unknown domain' do
      expect { Dhalang::PDF.get_from_url("https://unknown-domain") }.to raise_error(DhalangError, "net::ERR_NAME_NOT_RESOLVED at https://unknown-domain")
    end
  end
end

describe '#get_from_html' do
  context 'invalid html' do
    it 'returns empty content' do
      pdf_binary_content = Dhalang::PDF.get_from_html("")
      expect(pdf_binary_content.empty?).to be true
    end
  end

  context 'valid html' do
    it 'returns a pdf with the html' do
      html = "<html><head></head><body><h1>hello world</h1></body></html>"
      pdf_binary_content = Dhalang::PDF.get_from_html(html)
      pdf_reader = PDF::Reader.new(create_pdf_file(pdf_binary_content).path)
      expect(pdf_reader.page(1).to_s.include?("hello world")).to be true
    end
  end
end

def create_pdf_file(binary_pdf_content)
  pdf_file = Tempfile.new('pdf')
  pdf_file.binmode
  pdf_file.write(binary_pdf_content)
  pdf_file.rewind
  pdf_file
end