# frozen_string_literal: true

module CsvToYaml
  # Converter class handles the actual conversion from CSV to YAML
  class Converter
    # Convert CSV file to YAML file
    #
    # @param input_csv [String] Path to input CSV file
    # @param output_yaml [String] Path to output YAML file
    # @return [void]
    # @raise [CsvToYaml::ConversionError] If any error occurs during conversion
    # @raise [CsvToYaml::EmptyFileError] If the input file is empty
    # @raise [CsvToYaml::InvalidCsvFormatError] If the input file is not in a valid CSV format
    def convert(input_csv, output_yaml)
      validate_csv_format(input_csv)
      data = read_csv(input_csv)
      write_yaml(data, output_yaml)
    rescue EmptyFileError => e
      raise e
    rescue InvalidCsvFormatError => e
      raise e
    rescue StandardError => e
      raise ConversionError, "Failed to convert CSV to YAML: #{e.message}"
    end

    private

    # Validate the format of the input file
    #
    # @param file_path [String] Path to the input file
    # @raise [CsvToYaml::EmptyFileError] If the file is empty
    # @raise [CsvToYaml::InvalidCsvFormatError] If the file is not a valid CSV
    def validate_csv_format(file_path)
      raise EmptyFileError, "Input file '#{file_path}' is empty" if File.zero?(file_path)

      File.open(file_path, "rb") do |file|
        first_line = file.readline.force_encoding("ASCII-8BIT")
        unless first_line.include?(",".b) || first_line.include?(";".b) || first_line.include?("\t".b)
          raise InvalidCsvFormatError, "The file content does not appear to be a valid CSV format"
        end
      end
    rescue EOFError
      raise ConversionError, "The input file is empty or not readable"
    end

    # Read and parse CSV file
    #
    # @param input_csv [String] Path to input CSV file
    # @return [Array<Hash>] Parsed CSV data
    def read_csv(input_csv)
      csv_data = CSV.read(input_csv, headers: true)
      csv_data.map { |row| convert_types(row.to_h) }
    end

    # Convert data types
    #
    # @param row [Hash] A row of CSV data
    # @return [Hash] Converted data
    def convert_types(row)
      row.each_with_object({}) do |(key, value), new_row|
        new_row[key] = infer_and_convert_type(value) unless key.nil?
      end
    end

    # Infer and convert the type of a value
    #
    # @param value [String] The value to convert
    # @return [Object] The converted value
    def infer_and_convert_type(value)
      case value
      when /\A\d+\z/ then value.to_i
      when /\A\d+\.\d+\z/ then value.to_f
      when /\A(true|false)\z/i then value.downcase == "true"
      else value
      end
    end

    # Write data to YAML file
    #
    # @param data [Array<Hash>] The data to write
    # @param output_yaml [String] Path to output YAML file
    # @return [void]
    def write_yaml(data, output_yaml)
      File.open(output_yaml, "w") do |f|
        f.write(data.to_yaml.sub(/^---\n/, ""))
      end
    end
  end
end
