# frozen_string_literal: true

module CsvToYaml
  # Base error class for CsvToYaml
  class Error < StandardError; end
  # Error raised when conversion fails
  class ConversionError < Error; end
  # Error raised when the input file is empty or not readable
  class EmptyFileError < Error; end
  # Error raised when the input file is not a valid CSV
  class InvalidCsvFormatError < Error; end
end
