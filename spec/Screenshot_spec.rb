require 'rspec'
require 'Dhalang'
require 'pdf/reader'
require 'fastimage'

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
      expect(File.zero?(create_image_file(png_binary_content))).to be false
    end

    it 'should return an image of type png' do
      png_binary_content = Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")
      file_path = create_image_file(png_binary_content).path
      expect(FastImage.type(file_path)).to be(:png)
    end

    it 'should raise DhalangError on unknown domain' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain") }.to raise_error(DhalangError, "net::ERR_NAME_NOT_RESOLVED at https://unknown-domain")
    end
  end

  context 'invalid option: "type"' do
    it 'should raise DhalangError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain", {type: "jpeg"}) }.to raise_error(DhalangError, 'Invalid option set: "type"')
    end
  end
end

describe '#get_from_url_as_jpeg' do
  context 'url without specified protocol' do
    it 'should raise InvalidURIError' do
      expect { Dhalang::Screenshot.get_from_url_as_jpeg("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'should not raise ArgumentError' do
      expect { Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com") }.to_not raise_error(URI::InvalidURIError)
    end

    it 'should return an object of type string' do
      expect(Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")).to be_an_instance_of(String)
    end

    it 'should return a file that is not empty' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")
      expect(File.zero?(create_image_file(jpeg_binary_content))).to be false
    end

    it 'should return an image of type jpeg' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")
      file_path = create_image_file(jpeg_binary_content).path
      expect(FastImage.type(file_path)).to be(:jpeg)
    end
  end

  context 'invalid option: "type"' do
    it 'should raise DhalangError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain", {type: "jpeg"}) }.to raise_error(DhalangError, 'Invalid option set: "type"')
    end
  end
end


def create_image_file(binary_content)
  image_file = Tempfile.new('test')
  image_file.binmode
  image_file.write(binary_content)
  image_file.rewind
  return image_file
end