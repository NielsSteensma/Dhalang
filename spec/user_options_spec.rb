require 'rspec'
require 'Dhalang'
require 'json'

OPTION_KEY_NAVIGATION_PARAMETERS = 'navigationParameters'
OPTION_KEY_NAVIGATION_TIMEOUT = 'timeout'
OPTION_KEY_USER_AGENT = "userAgent"

describe 'User option: navigation timeout' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_NAVIGATION_PARAMETERS][OPTION_KEY_NAVIGATION_TIMEOUT]).to be(500)
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"navigation_timeout": 500})
        end
    end
  
    context 'when not set' do
        it 'is passed with a default value of 10000 to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_NAVIGATION_PARAMETERS][OPTION_KEY_NAVIGATION_TIMEOUT]).to be(10000)
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com")
        end
    end
end

describe 'User option: user agent' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_USER_AGENT]).to eq("Googlebot/2.1 (+http://www.google.com/bot.html)")
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"user_agent": "Googlebot/2.1 (+http://www.google.com/bot.html)"})
        end
    end

    context 'when not set' do
        it 'is passed as an empty string to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_USER_AGENT]).to eq("")
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com")
        end
    end
end

def expectUserOption
    expect(Kernel).to receive(:system) do |*args|
        # First get all arguments between first opening and last closing bracket ( i.e. get the JSON ).
        unescapedJson = args[0][/\{(.*)}/,1]
        # Now remove all the slashes, as the JSON is sent as an escaped string.
        escapedJson =  unescapedJson.gsub('\\', '')
        # Add brackets at begin and end, convert string to hash.
        userOptions = JSON.load("{" + escapedJson + "}")
        # Execute the expectation block.
        yield(userOptions['userOptions'])
    end
end