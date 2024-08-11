# frozen_string_literal: true

module CsvToYaml
  # Base error class for CsvToYaml
  class Error < StandardError; end

  # Error raised when conversion fails
  class ConversionError < Error; end
end
