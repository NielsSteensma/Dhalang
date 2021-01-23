module Dhalang
    # Contains common logic for interacting with Puppeteer.
    class Puppeteer
        NODE_MODULES_PATH = Dir.pwd + '/node_modules/'.freeze
        private_constant :NODE_MODULES_PATH

        USER_OPTIONS = {
                navigationTimeout: 10000,
                navigationWaitUntil: 'load',
                navigationWaitForSelector: '',
                userAgent: '',
                isHeadless: true,
                viewPort: '',
                httpAuthenticationCredentials: '',
                isAutoHeight: false
        }
        private_constant :USER_OPTIONS

        DEFAULT_PDF_OPTIONS = {
            scale: 1,
            displayHeaderFooter: false,
            headerTemplate: '',
            footerTemplate: '',
            printBackground: true,
            landscape: false,
            pageRanges: '',
            format: 'A4',
            width: '',
            height: '',
            margin: { top: 36, right: 36, bottom: 20, left: 36 },
            preferCSSPageSiz: false
        }
        private_constant :DEFAULT_PDF_OPTIONS

        DEFAULT_PNG_OPTIONS = {
            fullPage: true,
            clip: nil,
            omitBackground: false
        }
        private_constant :DEFAULT_PNG_OPTIONS

        DEFAULT_JPEG_OPTIONS = {
            quality: 100,
            fullPage: true,
            clip: nil,
            omitBackground: false
        }
        private_constant :DEFAULT_JPEG_OPTIONS


        # Launches a new Node process, executing the (Puppeteer) script under the given script_path.
        #
        # @param [String] page_url              The url to pass to the goTo method of Puppeteer.
        # @param [String] script_path           The absolute path of the JS script to execute.
        # @param [String] temp_file_path        The absolute path of the temp file to use to write any actions from Puppeteer.
        # @param [String] temp_file_extension   The extension of the temp file.
        # @param [Object] options               Set of options to use, configurable by the user.
        def self.visit(page_url, script_path, temp_file_path, temp_file_extension, options)
            configuration = create_configuration(page_url, script_path, temp_file_path, temp_file_extension, options)

            command = "node #{script_path} #{Shellwords.escape(configuration)}"

            Open3.popen2e(command) do |_stdin, stdouterr, wait|
                return nil if wait.value.success?

                output = stdouterr.read.strip
                output = nil if output == ''
                message = output || "Exited with status #{wait.value.exitstatus}"
                raise DhalangError, message
            end
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
                userOptions: USER_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value]}.to_h,
                pdfOptions: DEFAULT_PDF_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }.to_h,
                pngOptions: DEFAULT_PNG_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }.to_h,
                jpegOptions: DEFAULT_JPEG_OPTIONS.map { |option, value| [option, options.has_key?(option) ? options[option] : value] }.to_h
            }.to_json
        end
    end
end
