require 'rspec'
require 'Dhalang'
require 'pdf/reader'
require 'fastimage'

describe '#get_from_url_as_png' do
  context 'url without specified protocol' do
    it 'should raise InvalidURIError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'returns a png image' do
      png_binary_content = Dhalang::Screenshot.get_from_url_as_png("https://www.google.com")
      file_path = create_image_file(png_binary_content).path
      expect(FastImage.type(file_path)).to be(:png)
    end

    it 'raises DhalangError on unknown domain' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain") }.to raise_error(DhalangError, "net::ERR_NAME_NOT_RESOLVED at https://unknown-domain")
    end
  end

  context 'invalid option: "type"' do
    it 'raises DhalangError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain", {type: "jpeg"}) }.to raise_error(DhalangError, 'Invalid option set: "type"')
    end
  end
end

describe '#get_from_url_as_jpeg' do
  context 'url without specified protocol' do
    it 'raises InvalidURIError' do
      expect { Dhalang::Screenshot.get_from_url_as_jpeg("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'returns an jpeg image' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url_as_jpeg("https://www.google.com")
      file_path = create_image_file(jpeg_binary_content).path
      expect(FastImage.type(file_path)).to be(:jpeg)
    end
  end

  context 'invalid option: "type"' do
    it 'raises DhalangError' do
      expect { Dhalang::Screenshot.get_from_url_as_png("https://unknown-domain", {type: "jpeg"}) }.to raise_error(DhalangError, 'Invalid option set: "type"')
    end
  end
end


def create_image_file(binary_content)
  image_file = Tempfile.new('test')
  image_file.binmode
  image_file.write(binary_content)
  image_file.rewind
  image_file
end