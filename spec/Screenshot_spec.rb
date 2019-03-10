require 'rspec'
require 'Dhalang'
require 'pdf/reader'

# Method: DhalangPDF.get_from_url
describe '#get_from_url_as_png' do
  context 'url without specified protocol' do
    it 'should raise InvalidURIError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'should not raise ArgumentError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://www.google.com") }.to_not raise_error(URI::InvalidURIError)
    end

    it 'should return an object of type string' do
      expect(Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")).to be_an_instance_of(String)
    end

    it 'should return a file that is not empty' do
      png_binary_content = Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")
      expect(File.zero?(create_png_file(png_binary_content))).to be false
    end
  end
end


def create_png_file(binary_png_content)
  png_file = Tempfile.new('png')
  png_file.binmode
  png_file.write(binary_png_content)
  png_file.rewind
  return png_file
end