# frozen_string_literal: true

module CsvToYaml
  # Converter class handles the actual conversion from CSV to YAML
  class Converter
    # Convert CSV file to YAML file
    #
    # @param input_csv [String] Path to input CSV file
    # @param output_yaml [String] Path to output YAML file
    # @return [void]
    # @raise [ConversionError] If any error occurs during conversion
    def convert(input_csv, output_yaml)
      data = read_csv(input_csv)
      write_yaml(data, output_yaml)
    rescue StandardError => e
      raise ConversionError, "Failed to convert CSV to YAML: #{e.message}"
    end

    private

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
