# spec/search/client_loader_spec.rb
require 'spec_helper'
require 'json'
require 'tempfile'
require_relative '../../../lib/search/client_loader'
require_relative '../../../lib/search/client'

RSpec.describe Search::ClientLoader do
  let(:sample_data) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' },
      { 'id' => 3, 'full_name' => 'Johnny Depp', 'email' => 'john@example.com' },
    ]
  end

  let(:temp_file) do
    file = Tempfile.new('clients.json')
    file.write(sample_data.to_json)
    file.rewind
    file
  end

  after do
    temp_file.close
    temp_file.unlink
  end

  describe '#initialize' do
    it 'loads clients from a JSON file' do
      loader = described_class.new(temp_file.path)
      expect(loader.all_clients.count).to eq(3)
    end

    it 'creates Client objects with correct attributes' do
      loader = described_class.new(temp_file.path)
      client = loader.all_clients.first

      expect(client).to be_a(Search::Client)
      expect(client.id).to eq(1)
      expect(client.full_name).to eq('John Doe')
      expect(client.email).to eq('john@example.com')
    end
  end

  describe '#all_clients' do
    it 'returns all clients loaded from the file' do
      loader = described_class.new(temp_file.path)
      expect(loader.all_clients.size).to eq(3)
    end
  end

  context 'with invalid JSON file' do
    it 'raises a JSON::ParserError' do
      bad_file = Tempfile.new('bad.json')
      bad_file.write('{ bad json')
      bad_file.rewind

      expect {
        described_class.new(bad_file.path)
      }.to raise_error(JSON::ParserError)

      bad_file.close
      bad_file.unlink
    end
  end
end
