# frozen_string_literal: true

require_relative "csv_to_yaml/version"
require_relative "csv_to_yaml/converter"
require_relative "csv_to_yaml/errors"
require "csv"
require "yaml"

# CsvToYaml is a module that provides functionality to convert CSV files to YAML format.
#
# This gem allows you to easily transform data from CSV (Comma-Separated Values) format
# to YAML (YAML Ain't Markup Language) format. It handles various data types and
# attempts to infer and convert them appropriately.
#
# @example Converting a CSV file to YAML
#   CsvToYaml.convert('input.csv', 'output.yaml')
#
# @note This gem assumes that the input CSV file has headers.
#
# @see https://github.com/kazuyainoue0124/csv_to_yaml for more information and usage examples.
module CsvToYaml
  class << self
    # Converts a CSV file to YAML format
    #
    # @param input_csv [String] Path to the input CSV file
    # @param output_yaml [String] Path to the output YAML file
    # @return [void]
    # @raise [CsvToYaml::ConversionError] If any error occurs during conversion
    # @raise [CsvToYaml::EmptyFileError] If the input file is empty
    # @raise [CsvToYaml::InvalidCsvFormatError] If the input file is not in a valid CSV format
    def convert(input_csv, output_yaml)
      Converter.new.convert(input_csv, output_yaml)
    end
  end
end
