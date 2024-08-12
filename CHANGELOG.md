## [Unreleased]

## [0.1.0] - 2024-08-03

### Added

- Initial release of CsvToYaml gem
- Core functionality to convert CSV files to YAML format
- Automatic data type inference for integers, floats, booleans, and strings
- Error handling for empty files and invalid CSV formats
- Basic documentation including README and this CHANGELOG

### Features

- `CsvToYaml.convert` method to convert CSV files to YAML
- `CsvToYaml::Converter` class for handling the conversion process
- Custom error classes: `ConversionError`, `EmptyFileError`, and `InvalidCsvFormatError`

### Dependencies

- Uses standard library modules: CSV and YAML
