# CsvToYaml

CsvToYaml is a Ruby gem designed to simplify the process of converting CSV (Comma Separated Values) files into YAML (YAML Ain't Markup Language) format, particularly for use in Rails applications where YAML files are needed for seeding data into the database. This gem was born out of a real-world need when seed data was provided in CSV format, but the project required YAML for `rails db:seed`.

## Features

- **CSV to YAML Conversion for Rails Seeds:** Easily convert CSV files into YAML format, making it straightforward to create seed data for Rails applications.
- **Automatic Data Type Inference:** The gem intelligently infers and converts data types, including boolean values, ensuring your YAML files are accurate and ready to use directly without further adjustments.
- **Flexible File Handling:** Input CSV files can be read from any directory, and output YAML files can be saved to any directory, providing flexibility in your project setup.
- **Error Handling:** Robust handling of empty files, invalid CSV formats, and other potential issues, providing clear error messages to assist in troubleshooting.
- **Simple API:** Designed with ease of use in mind, the API allows you to convert files with minimal setup.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add csv_to_yaml

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install csv_to_yaml

## Usage

Here's a basic example of how to use CsvToYaml:

```ruby
require 'csv_to_yaml'

# Convert a CSV file to a YAML file for Rails seed data
CsvToYaml.convert('path/to/input.csv', 'path/to/output.yaml')
```

This will read the `input.csv` file from any specified directory, convert its contents to YAML format, and save the result to the specified directory as `output.yaml`.

## Example: Converting CSV to YAML and Seeding Data in Rails

Here's a step-by-step example of how to convert a CSV file to YAML and then use it to seed data into a Rails application.

### Step 1: CSV File

Suppose you have a CSV file named `data/users.csv` with the following content:

```csv:data/users.csv
id,name,age,verified
1,Alice,30,true
2,Bob,25,false
3,Charlie,35,true
4,David,40,false
5,Eve,20,true
```

### Step 2: Convert CSV to YAML

Using CsvToYaml, you can convert this CSV file into a YAML file and save it to any directory of your choice:

```ruby
require 'csv_to_yaml'

CsvToYaml.convert('data/users.csv', 'db/seeds/users.yaml')
```

This will generate an `users.yaml` file at the specified location (`db/seeds/users.yaml`) with the following content:

```yaml:db/seeds/users.yaml
- id: 1
  name: Alice
  age: 30
  verified: true
- id: 2
  name: Bob
  age: 25
  verified: false
- id: 3
  name: Charlie
  age: 35
  verified: true
- id: 4
  name: David
  age: 40
  verified: false
- id: 5
  name: Eve
  age: 20
  verified: true
```

In this YAML file, the data types (including integers and booleans) are correctly inferred and preserved, so you can use it directly in your Rails application without worrying about type mismatches, which can occur if the values were incorrectly treated as strings.

### Step 3: Use YAML File to Seed Data

You can now use this YAML file to seed data into your Rails application. First, load the YAML file in your `db/seeds.rb`:

```ruby
require 'yaml'

seed_data = YAML.load_file(Rails.root.join('db', 'seeds', 'users.yaml'))

seed_data.each do |record|
  User.create!(record)
end
```

Finally, run the Rails seed command to populate your database:

```bash
$ rails db:seed
```

Now, your database will be populated with the data from the original CSV file, converted to YAML with the correct data types.

## Error Handling

CsvToYaml provides specific error classes to handle different scenarios, ensuring that you can troubleshoot issues effectively:

```ruby
begin
  CsvToYaml.convert('data/users.csv', 'db/seeds/users.yaml')
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
