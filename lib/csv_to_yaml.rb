# frozen_string_literal: true

require_relative "csv_to_yaml/version"
require_relative "csv_to_yaml/converter"
require_relative "csv_to_yaml/errors"
require "csv"
require "yaml"

module CsvToYaml
  class << self
    # Converts a CSV file to YAML format
    #
    # @param input_csv [String] Path to the input CSV file
    # @param output_yaml [String] Path to the output YAML file
    # @return [void]
    # @raise [CsvToYaml::ConversionError] If any error occurs during conversion
    def convert(input_csv, output_yaml)
      Converter.new.convert(input_csv, output_yaml)
    end
  end
end
