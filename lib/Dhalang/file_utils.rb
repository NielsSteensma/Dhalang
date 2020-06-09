module Dhalang
    # Contains common logic for files. 
    class FileUtils

        # Reads the file under the given filepath as a binary.
        #
        # @param [String] file_path The absolute path of the file to read.
        #
        # @return [String]      The binary content under the file_path.
        def self.read_binary(file_path)
            IO.binread(file_path)
        end

        # Creates a new temp file.
        #
        # @param [String] extension The extension of the file.
        # @param [String] content   The content of the file. (Optional)
        #
        # @return [Tempfile]    The created temp file.
        def self.create_temp_file(extension, content = nil)
            temp_file = Tempfile.new(["dhalang",".#{extension}"])
            unless(content == nil)
                temp_file.write(content)
                temp_file.rewind
            end
            temp_file
        end

        # Deletes the given file.
        #
        # @param [File] file    The file to delete.
        def self.delete(file)
            file.close unless file.closed?
            file.unlink
        end
    end
end