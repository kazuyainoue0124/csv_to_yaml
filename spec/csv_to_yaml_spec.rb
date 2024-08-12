# frozen_string_literal: true

RSpec.describe CsvToYaml do
  let(:input_csv) { Tempfile.new(["input", ".csv"]) }
  let(:output_yaml) { Tempfile.new(["output", ".yml"]) }

  after do
    input_csv.close
    input_csv.unlink
    output_yaml.close
    output_yaml.unlink
  end

  it "has a version number" do
    expect(CsvToYaml::VERSION).not_to be nil
  end

  describe ".convert" do
    context "Positive tests" do
      # Test for valid CSV data conversion
      context "with valid csv data" do
        before do
          input_csv.write(<<~CSV)
            id,name,age,salary,active
            1,Alice,30,50000.0,true
            2,Bob,25,40000.5,false
            3,Charlie,35,60000.0,true
          CSV
          input_csv.rewind
        end
  
        it "converts CSV to YAML with correct data types" do
          described_class.convert(input_csv.path, output_yaml.path)
          yaml_content = YAML.load_file(output_yaml.path)
  
          expect(yaml_content).to eq([
            { "id" => 1, "name" => "Alice",   "age" => 30, "salary" => 50_000.0, "active" => true },
            { "id" => 2, "name" => "Bob",     "age" => 25, "salary" => 40_000.5, "active" => false },
            { "id" => 3, "name" => "Charlie", "age" => 35, "salary" => 60_000.0, "active" => true }
          ])
        end
      end

      # Test for overwriting existing output file
      context "when output file already exists" do
        let(:existing_output) { Tempfile.new(["existing_output", ".yml"]) }
  
        before do
          existing_output.write("Existing content\n")
          existing_output.rewind
  
          input_csv.write(<<~CSV)
            id,name
            1,Alice
            2,Bob
          CSV
          input_csv.rewind
        end
  
        after do
          existing_output.close
          existing_output.unlink
        end
  
        it "overwrites the existing file" do
          described_class.convert(input_csv.path, existing_output.path)
          yaml_content = YAML.load_file(existing_output.path)
  
          expect(yaml_content).to eq([
            { "id" => 1, "name" => "Alice" },
            { "id" => 2, "name" => "Bob" }
          ])
          expect(File.read(existing_output.path)).not_to include("Existing content")
        end
      end

      # Test for creating new output file
      context "when output file does not exist" do
        let(:non_existent_output) { "non_existent_output.yml" }
  
        before do
          input_csv.write(<<~CSV)
            id,name
            1,Alice
            2,Bob
          CSV
          input_csv.rewind
        end
  
        after do
          File.delete(non_existent_output) if File.exist?(non_existent_output)
        end
  
        it "creates a new file" do
          expect(File.exist?(non_existent_output)).to be false
          described_class.convert(input_csv.path, non_existent_output)
          expect(File.exist?(non_existent_output)).to be true
  
          yaml_content = YAML.load_file(non_existent_output)
          expect(yaml_content).to eq([
            { "id" => 1, "name" => "Alice" },
            { "id" => 2, "name" => "Bob" }
          ])
        end
      end

      # Test for processing large files
      context "with large CSV file" do
        before do
          input_csv.write("id,name,value\n")
          10_000.times do |i|
            input_csv.write("#{i},name#{i},#{i * 10}\n")
          end
          input_csv.rewind
        end
  
        it "processes large files correctly" do
          described_class.convert(input_csv.path, output_yaml.path)
          yaml_content = YAML.load_file(output_yaml.path)
  
          expect(yaml_content.size).to eq(10_000)
          expect(yaml_content.first).to eq({ "id" => 0, "name" => "name0", "value" => 0 })
          expect(yaml_content.last).to eq({ "id" => 9999, "name" => "name9999", "value" => 99_990 })
        end
      end
    end

    context "Edge cases" do
      # Test for header-only file
      context "with CSV file containing only headers" do
        before do
          input_csv.write("id,name,age\n")
          input_csv.rewind
        end
  
        it "produces an empty YAML file" do
          described_class.convert(input_csv.path, output_yaml.path)
          yaml_content = YAML.load_file(output_yaml.path)
  
          expect(yaml_content).to eq([])
        end
      end

      # Test for mixed data types
      context "with CSV containing mixed row data types" do
        before do
          input_csv.write(<<~CSV)
            id,name,value
            1,Test,123
            2,Another test,456.78
            3,Yet another test,true
            4,String test,abc
          CSV
          input_csv.rewind
        end
  
        it "converts data types correctly" do
          described_class.convert(input_csv.path, output_yaml.path)
          yaml_content = YAML.load_file(output_yaml.path)
  
          expect(yaml_content).to eq([
            { "id" => 1, "name" => "Test",             "value" => 123 },
            { "id" => 2, "name" => "Another test",     "value" => 456.78 },
            { "id" => 3, "name" => "Yet another test", "value" => true },
            { "id" => 4, "name" => "String test",      "value" => "abc" }
          ])
        end
      end

      # Test for empty data rows
      context "with empty data rows" do
        before do
          input_csv.write(<<~CSV)
            id,name,age
            1,Alice,
            2,,
            3,Bob,30
          CSV
          input_csv.rewind
        end
  
        it "handles empty data rows correctly" do
          described_class.convert(input_csv.path, output_yaml.path)
          yaml_content = YAML.load_file(output_yaml.path)
  
          expect(yaml_content).to eq([
            { "id" => 1, "name" => "Alice", "age" => nil },
            { "id" => 2, "name" => nil,     "age" => nil },
            { "id" => 3, "name" => "Bob",   "age" => 30 }
          ])
        end
      end
    end

    context "Error handling" do
      # Test for invalid input file path
      context "with invalid input file path" do
        it "raises a ConversionError" do
          expect do
            described_class.convert("invalid.csv", output_yaml.path)
          end.to raise_error(CsvToYaml::ConversionError, /Failed to convert CSV to YAML/)
        end
      end
  
      # Test for invalid output file path
      context "with invalid output file path" do
        it "raises a ConversionError" do
          expect do
            described_class.convert(input_csv.path, "/invalid/path/output.yml")
          end.to raise_error(CsvToYaml::ConversionError, /Failed to convert CSV to YAML/)
        end
      end

      # Test for completely empty CSV file
      context "with completely empty CSV file" do
        before do
          input_csv.write("")
          input_csv.rewind
        end
  
        it "raises a ConversionError" do
          expect do
            described_class.convert(input_csv.path, output_yaml.path)
          end.to raise_error(CsvToYaml::ConversionError, /Failed to convert CSV to YAML/)
        end
      end

      # Test for the extension of the input file
      context "with non-CSV input file" do
        let(:non_csv_file) { Tempfile.new(["non_csv", ".txt"]) }
  
        before do
          non_csv_file.write("This is not a CSV file\nIt's just a plain text file")
          non_csv_file.rewind
        end
  
        after do
          non_csv_file.close
          non_csv_file.unlink
        end
  
        it "raises an error" do
          expect do
            described_class.convert(non_csv_file.path, output_yaml.path)
          end.to raise_error(CsvToYaml::InvalidExtensionError, /Input file '#{non_csv_file.path}' does not have a .csv extension/)
        end
      end
    end
  end
end
