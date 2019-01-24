require 'rspec'
require 'DhalangPDF'
require 'pdf/reader'

describe '#get_from_url' do
  context 'url without specified protocol' do
    it 'should raise InvalidURIError' do
      expect { DhalangPDF.get_from_url("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'should not raise ArgumentError' do
      expect { DhalangPDF.get_from_url("https://www.google.com") }.to_not raise_error(URI::InvalidURIError)
    end

    it 'should return an object of type TempFile' do
      expect(DhalangPDF.get_from_url("https://www.google.com")).to be_an_instance_of(Tempfile)
    end

    it 'should return a file that is not empty' do
      pdf = DhalangPDF.get_from_url("https://www.google.com")
      expect(File.zero?(pdf.path)).to be false
    end

    it 'should return pdf containing the webpage' do
      pdf = DhalangPDF.get_from_url("https://www.google.com")
      pdf_reader = PDF::Reader.new(pdf.path)
      expect(pdf_reader.page(1).to_s.include?("Google")).to be true
    end
  end
end