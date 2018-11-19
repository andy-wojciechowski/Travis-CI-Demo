require "jekyll"
require "json"
require "rubyXL"

class SampleExcelGenerator < Jekyll::Generator
    EXCEL_FILE_NAME = "sample.xlsx"
    
    def generate(site)
        make_data_directory_if_necessary()
        json = parse_and_create_json()
        create_json_file(json)
    end

    def parse_and_create_json()
        parent_directory = File.expand_path(".", Dir.pwd)
        full_excel_path = File.join(parent_directory, EXCEL_FILE_NAME)
        excel_data = []
        workbook = RubyXL::Parser.parse(full_excel_path)
        worksheet = workbook[0]
        current_first_name = ""
        current_last_name = ""
        worksheet.each { |row|
            row && row.cells.each { |cell|
                if cell && cell.value && cell.row != 0
                    if cell.column === 0
                        current_first_name = cell.value
                    elsif cell.column === 1
                        current_last_name = cell.value
                        excel_data << ExcelData.new(current_first_name, current_last_name)
                    end
                end
            }
        }
        return excel_data.map{|data| {FirstName: data.first_name, LastName: data.last_name}}.to_json
    end

    def create_json_file(json)
        file_name = "#{path}/excelsamples.json"
        open(file_name, "wb") do |file|
            file << JSON.generate(json)
        end
    end

    def path
        parent_directory = File.expand_path(".", Dir.pwd)
        return File.join(parent_directory, "_data")
    end

    def make_data_directory_if_necessary()
        Dir.mkdir(path) unless Dir.exist?(path)
    end
end

class ExcelData
    def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
    end

    def first_name
        @first_name
    end

    def last_name
        @last_name
    end
end