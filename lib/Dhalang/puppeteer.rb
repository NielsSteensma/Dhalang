module Dhalang
    # Contains common logic for interacting with Puppeteer.
    class Puppeteer
        NODE_MODULES_PATH = Dir.pwd + '/node_modules/'.freeze
        private_constant :NODE_MODULES_PATH

        NAVIGATION_TIMEOUT = 10000
        private_constant :NAVIGATION_TIMEOUT

        NAVIGATION_WAIT_UNTIL = 'load'
        private_constant :NAVIGATION_WAIT_UNTIL

        USER_AGENT = ''
        private_constant :USER_AGENT


        # Launches a new Node process, executing the (Puppeteer) script under the given script_path.
        #
        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] script_path           The absolute path of the JS script to execute.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        # @param [Object] options               Set of options to use, configurable by the user.
        def self.visit(page_url, script_path, temp_file_path, temp_file_extension, options)
            configuration = create_configuration(page_url, script_path, temp_file_path, temp_file_extension, options)
            Kernel.system("node #{script_path} #{Shellwords.escape(configuration)}")
        end

        
        # Returns a JSON string with the configuration to use within the Puppeteer script.
        #
        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] script_path           The absolute path of the JS script to execute.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        # @param [Hash]   options               Set of options to use, configurable by the user.
        private_class_method def self.create_configuration(page_url, script_path, temp_file_path, temp_file_extension, options)
            {
                webPageUrl: page_url,
                tempFilePath: temp_file_path, 
                puppeteerPath: NODE_MODULES_PATH, 
                imageType: temp_file_extension,
                userOptions: {
                    navigationParameters: {
                        timeout: options.has_key?(:navigation_timeout) ? options[:navigation_timeout] : NAVIGATION_TIMEOUT,
                        waitUntil: NAVIGATION_WAIT_UNTIL
                    },
                    userAgent: options.has_key?(:user_agent) ? options[:user_agent] : USER_AGENT
                }
            }.to_json
        end
    end
end