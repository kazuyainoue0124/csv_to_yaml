# frozen_string_literal: true

require_relative "lib/csv_to_yaml/version"

Gem::Specification.new do |spec|
  spec.name = "csv_to_yaml"
  spec.version = CsvToYaml::VERSION
  spec.authors = ["kazuyainoue0124"]
  spec.email = ["kazuyainoue0124@users.noreply.github.com"]

  spec.summary = "A gem to convert CSV data to YAML format, particularly for Rails seed data."
  spec.description = "CsvToYaml is a Ruby gem that converts CSV files to YAML format, with automatic data type inference, allowing seamless creation of YAML files for Rails seed data."
  spec.homepage = "https://github.com/kazuyainoue0124/csv_to_yaml"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kazuyainoue0124/csv_to_yaml"
  spec.metadata["changelog_uri"] = "https://github.com/kazuyainoue0124/csv_to_yaml/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.test_files = Dir.glob("spec/**/*_spec.rb")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
