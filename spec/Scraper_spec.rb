require 'rspec'
require 'Dhalang'

describe '#html' do
  context 'url without specified protocol' do
    it 'raises InvalidURIError' do
      expect { Dhalang::Scraper.html("google.com") }.to raise_error(URI::InvalidURIError)
    end
  end

  context 'valid url' do
    it 'returns scraped html' do
      html = Dhalang::Scraper.html("https://www.google.com")
      expect(html.empty?).to be false
    end
  end
end