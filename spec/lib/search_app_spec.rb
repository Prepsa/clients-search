# spec/lib/search_spec.rb

require 'spec_helper'
require 'tempfile'
require_relative '../../lib/search_app'

RSpec.describe SearchApp do
  let(:sample_data) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' },
      { 'id' => 3, 'full_name' => 'Johnny Depp', 'email' => 'john@example.com' }
    ]
  end

  let(:empty_data) { [] }

  let(:temp_file) do
    file = Tempfile.new('clients.json')
    file.write(sample_data.to_json)
    file.rewind
    file
  end

  let(:empty_file) do
    file = Tempfile.new('empty_clients.json')
    file.write(empty_data.to_json)
    file.rewind
    file
  end

  after do
    temp_file.close
    temp_file.unlink
    empty_file.close
    empty_file.unlink
  end

  describe '.run' do
    it 'creates a new instance and calls search_clients' do
      app_instance = instance_double(described_class)
      allow(described_class).to receive(:new).and_return(app_instance)
      allow(app_instance).to receive(:search_clients)

      described_class.run

      expect(app_instance).to have_received(:search_clients)
    end
  end

  describe '#initialize' do
    it 'loads clients from the JSON file' do
      allow(Search::ClientLoader).to receive(:new).and_call_original
      app = described_class.new
      expect(Search::ClientLoader).to have_received(:new).with('db/data/clients.json')
      expect(app.clients).to be_an(Array)
    end
  end

  describe '#search_clients' do
    context 'when no clients are found' do
      it 'displays a message and exits' do
        allow(Search::ClientLoader).to receive(:new).and_return(
          instance_double(Search::ClientLoader, all_clients: [])
        )
        expect { described_class.new.search_clients }.to output(/No clients data found/).to_stdout
      end
    end

    context 'when clients are found' do
      before do
        allow_any_instance_of(described_class).to receive(:loop).and_yield
        allow_any_instance_of(described_class).to receive(:handle_user_option).and_return(false)
      end

      it 'displays the welcome message' do
        expect { described_class.new.search_clients }.to output(/Welcome to 'Client Search App'/).to_stdout
      end

      it 'calls display_menu and handle_user_option' do
        app = described_class.new
        allow(app).to receive(:display_menu)
        allow(app).to receive(:handle_user_option).and_return(false)

        app.search_clients

        expect(app).to have_received(:display_menu)
        expect(app).to have_received(:handle_user_option)
      end
    end
  end

  describe '#handle_user_option' do
    let(:app) { described_class.new }

    before do
      allow(app).to receive(:search_duplicate_emails)
      allow(app).to receive(:search_by_name)
    end

    it 'calls search_duplicate_emails for option 1' do
      allow(app).to receive(:gets).and_return("1\n")
      app.send(:handle_user_option, 1)
      expect(app).to have_received(:search_duplicate_emails)
    end

    it 'calls search_by_name for option 2' do
      allow(app).to receive(:gets).and_return("2\n")
      app.send(:handle_user_option, 2)
      expect(app).to have_received(:search_by_name)
    end

    it 'exits for option 3' do
      allow(app).to receive(:gets).and_return("3\n")
      expect { app.send(:handle_user_option, 3) }
        .to output(/Exiting the program/).to_stdout
      expect(app.send(:handle_user_option, 3)).to be false
    end

    it 'displays error for invalid option' do
      allow(app).to receive(:gets).and_return("99\n")
      expect { app.send(:handle_user_option, 99) }
        .to output(/Invalid option/).to_stdout
    end
  end

  describe '#search_continue' do
    let(:app) { described_class.new }

    it 'returns true for yes or y' do
      %w[yes y].each do |input|
        allow(app).to receive(:gets).and_return("#{input}\n")
        expect(app.send(:search_continue)).to be true
      end
    end

    it 'returns false for no or n' do
      %w[no n].each do |input|
        allow(app).to receive(:gets).and_return("#{input}\n")
        expect { app.send(:search_continue) }
          .to output(/Exiting the app/).to_stdout
        expect(app.send(:search_continue)).to be(false)
      end
    end

    it 'returns false for invalid input' do
      allow(app).to receive(:gets).and_return("invalid\n")
      expect { app.send(:search_continue) }
        .to output(/Invalid input/).to_stdout
      expect(app.send(:search_continue)).to be(false)
    end
  end
end
