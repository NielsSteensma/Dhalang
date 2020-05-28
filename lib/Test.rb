require_relative 'Dhalang'

class Test
    def self.test_pdf
        data = Dhalang::PDF.get_from_url("http://www.google.com")
        puts data
    end
end

Test.test_pdf()