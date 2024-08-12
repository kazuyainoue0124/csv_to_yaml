# CsvToYaml

CsvToYaml is a Ruby gem that provides an easy way to convert CSV(Comma Separated Values) files to YAML(YAML Ain't Markup Language) format. It handles various data types and attempts to infer and convert them appropriately.

## Features

- Convert CSV files to YAML format
- Automatic data type inference and conversion
- Handles empty files and invalid CSV formats
- Simple and easy-to-use API

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add csv_to_yaml

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install csv_to_yaml

## Usage

Here's a basic example of how to use CsvToYaml:

```ruby
require 'csv_to_yaml'

# Convert a CSV file to YAML
CsvToYaml.convert('input.csv', 'output.yaml')
```

This will read the `input.csv` file, convert its contents to YAML format, and save the result to `output.yaml`.

## Error Handling

CsvToYaml provides specific error classes to handle different scenarios:

```ruby
begin
  CsvToYaml.convert('input.csv', 'output.yaml')
rescue CsvToYaml::EmptyFileError
  puts "The input file is empty"
rescue CsvToYaml::InvalidCsvFormatError
  puts "The input file is not a valid CSV"
rescue CsvToYaml::ConversionError => e
  puts "Conversion failed: #{e.message}"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kazuyainoue0124/csv_to_yaml.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
