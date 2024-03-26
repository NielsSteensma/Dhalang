module Dhalang
  class NodeScriptInvoker

    # Executes JS script under given script_path by launching a new Node process.
    #
    # @param [String] script_path           Absolute path of the JS script to execute.
    # @param [Configuration] configuration         Configuration to use by j.
    def self.execute_script(script_path, configuration)
      command = create_node_command(script_path, configuration)
      Open3.popen2e(command) do |_stdin, stdouterr, wait|
        return nil if wait.value.success?

        output = stdouterr.read.strip
        output = nil if output == ''
        message = output || "Exited with status #{wait.value.exitstatus}"
        raise DhalangError, message
      end
    end

    # Returns a [String] with the node command to invoke the provided script with the configuration.
    #
    # @param [String] script_path           Absolute path of JS script to invoke.
    # @param [Object] configuration         JSON with options to use for Puppeteer.
    private_class_method def self.create_node_command(script_path, configuration)
      "node #{script_path} #{Shellwords.escape(configuration.json)}"
    end
  end
end
