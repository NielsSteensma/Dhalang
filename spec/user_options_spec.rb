require 'rspec'
require 'Dhalang'
require 'json'

OPTION_KEY_NAVIGATION_TIMEOUT = 'navigationTimeout'
OPTION_KEY_USER_AGENT = "userAgent"
OPTION_KEY_IS_HEADLESS = "isHeadless"
OPTION_KEY_VIEW_PORT = "viewPort"
OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS = "httpAuthenticationCredentials"

describe 'User option: navigation timeout' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_NAVIGATION_TIMEOUT]).to be(12000)
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"navigationTimeout": 12000})
        end
    end

    context 'when not set' do
        it 'is passed with a default value of 10000 to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_NAVIGATION_TIMEOUT]).to be(10000)
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
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"userAgent": "Googlebot/2.1 (+http://www.google.com/bot.html)"})
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

describe 'User option: headless mode' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_IS_HEADLESS]).to be false
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"isHeadless": false})
        end
    end

    context 'when not set' do
        it 'is passed as with a value of true to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_IS_HEADLESS]).to be true
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"isHeadless": true})
        end
    end
end

describe 'User option: view port' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_VIEW_PORT]['width']).to eq(1920)
                expect(userOptions[OPTION_KEY_VIEW_PORT]['height']).to eq(1080)
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"viewPort": {"width": 1920, "height": 1080}})
        end
    end

    context 'when not set' do
        it 'is passed as an empty string to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_VIEW_PORT]).to eq("")
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com")
        end
    end
end

describe 'User option: http authentication credentials' do
    context 'when set' do
        it 'is passed as set to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]['username']).to eq("admin")
                expect(userOptions[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]['password']).to eq("1234")
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com", {"httpAuthenticationCredentials": {"username": "admin", "password": "1234"}})
        end
    end

    context 'when not set' do
        it 'is passed as an empty string to the JS script' do
            expectUserOption do |userOptions|
                expect(userOptions[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]).to eq("")
            end
            Dhalang::Screenshot.get_from_url_as_png("http://www.google.com")
        end
    end
end

def expectUserOption
    expect(Open3).to receive(:popen2e) do |*args|
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