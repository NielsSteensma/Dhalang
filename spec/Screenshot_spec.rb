require 'rspec'
require 'Dhalang'
require 'pdf/reader'
require 'fastimage'

describe '#get_from_url' do
  context 'url without specified protocol' do
    it 'raises InvalidURIError' do
      expect { Dhalang::Screenshot.get_from_url("google.com", :jpeg) }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'jpeg' do
    it 'returns a jpeg image' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url("https://www.google.com", :jpeg)
      file_path = create_image_file(jpeg_binary_content).path
      expect(FastImage.type(file_path)).to be(:jpeg)
    end
  end

  context 'png' do
    it 'returns a png image' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url("https://www.google.com", :png)
      file_path = create_image_file(jpeg_binary_content).path
      expect(FastImage.type(file_path)).to be(:png)
    end
  end

  context 'webp' do
    it 'returns a webp image' do
      jpeg_binary_content = Dhalang::Screenshot.get_from_url("https://www.google.com", :webp)
      file_path = create_image_file(jpeg_binary_content).path
      expect(FastImage.type(file_path)).to be(:webp)
    end
  end

  context 'invalid image format' do
    it 'raises DhalangError' do
      expect { Dhalang::Screenshot.get_from_url("https://unknown-domain", :invalid_image_format) }.to raise_error(DhalangError, 'Unsupported image type')
    end
  end

  context 'invalid option' do
    it 'raises DhalangError' do
      expect { Dhalang::Screenshot.get_from_url("https://unknown-domain", :jpeg, {type: "jpeg"}) }.to raise_error(DhalangError, 'Invalid option set: "type"')
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