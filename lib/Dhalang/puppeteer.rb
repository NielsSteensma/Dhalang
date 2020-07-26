module Dhalang
    # Contains common logic for interacting with Puppeteer.
    class Puppeteer
        NODE_MODULES_PATH = Dir.pwd + '/node_modules/'.freeze
        private_constant :NODE_MODULES_PATH


        # Launches a new Node process, executing the (Puppeteer) script under the given script_path.
        #
        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] script_path           The absolute path of the JS script to execute.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        def self.visit(page_url, script_path, temp_file_path, temp_file_extension)
            configuration = create_configuration(page_url, script_path, temp_file_path, temp_file_extension)
            system("node #{script_path} #{Shellwords.escape(configuration)}")
        end

        
        # Returns a JSON string with the configuration to use within the Puppeteer script.
        #
        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] script_path           The absolute path of the JS script to execute.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        private_class_method def self.create_configuration(page_url, script_path, temp_file_path, temp_file_extension)
            {
                webPageUrl: page_url,
                tempFilePath: temp_file_path, 
                puppeteerPath: NODE_MODULES_PATH, 
                imageType: temp_file_extension
            }.to_json
        end
    end
end