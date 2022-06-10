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
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_NAVIGATION_TIMEOUT]).to be(12000)
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "navigationTimeout": 12000 })
    end
  end

  context 'when not set' do
    it 'is passed with a default value of 10000 to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_NAVIGATION_TIMEOUT]).to be(10000)
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp)
    end
  end
end

describe 'User option: user agent' do
  context 'when set' do
    it 'is passed as set to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_USER_AGENT]).to eq("Googlebot/2.1 (+http://www.google.com/bot.html)")
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "userAgent": "Googlebot/2.1 (+http://www.google.com/bot.html)" })
    end
  end

  context 'when not set' do
    it 'is passed as an empty string to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_USER_AGENT]).to eq("")
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp)
    end
  end
end

describe 'User option: headless mode' do
  context 'when set' do
    it 'is passed as set to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_IS_HEADLESS]).to be false
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "isHeadless": false })
    end
  end

  context 'when not set' do
    it 'is passed as with a value of true to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_IS_HEADLESS]).to be true
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "isHeadless": true })
    end
  end
end

describe 'User option: view port' do
  context 'when set' do
    it 'is passed as set to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_VIEW_PORT]['width']).to eq(1920)
        expect(user_options[OPTION_KEY_VIEW_PORT]['height']).to eq(1080)
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "viewPort": { "width": 1920, "height": 1080 } })
    end
  end

  context 'when not set' do
    it 'is passed as an empty string to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_VIEW_PORT]).to eq("")
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp)
    end
  end
end

describe 'User option: http authentication credentials' do
  context 'when set' do
    it 'is passed as set to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]['username']).to eq("admin")
        expect(user_options[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]['password']).to eq("1234")
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp, { "httpAuthenticationCredentials": { "username": "admin", "password": "1234" } })
    end
  end

  context 'when not set' do
    it 'is passed as an empty string to the JS script' do
      expect_user_option do |user_options|
        expect(user_options[OPTION_KEY_HTTP_AUTHENTICATION_CREDENTIALS]).to eq("")
      end
      Dhalang::Screenshot.get_from_url("http://www.google.com", :webp)
    end
  end
end

def expect_user_option
  expect(Open3).to receive(:popen2e) do |*args|
    # First get all arguments between first opening and last closing bracket ( i.e. get the JSON ).
    unescaped_json = args[0][/\{(.*)}/,1]
    # Now remove all the slashes, as the JSON is sent as an escaped string.
    escaped_json =  unescaped_json.gsub('\\', '') 
    # Add brackets at begin and end, convert string to hash.
    user_options = JSON.parse("{#{escaped_json}}")
    # Execute the expectation block.
    yield(user_options['userOptions'])
  end
end