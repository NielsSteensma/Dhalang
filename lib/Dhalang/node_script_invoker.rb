module Dhalang
  class NodeScriptInvoker

    # Executes JS script under given script_path by launching a new Node process.
    #
    # @param [String] script_path           Absolute path of the JS script to execute.
    # @param [Object] options               Set of options to use, configurable by the user.
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

    # Executes JS script under given script_path by launching a new Node process. Once script is finished returns
    # received stdout.
    #
    # @param [String] script_path           The absolute path of the JS script to execute.
    # @param [Object] configuration         Set of options to use, configurable by the user.
    #
    # @return [String] stdout received from script.
    def self.execute_script_and_read_stdout(script_path, configuration)
      command = create_node_command(script_path, configuration)
      Open3.popen3(command) do |_stdin, stdout, stderr, wait|
        if wait.value.success?
          return stdout.read.strip
        end
        output = stderr.read.strip
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
      "node #{script_path} #{Shellwords.escape(configuration)}"
    end
  end
end
