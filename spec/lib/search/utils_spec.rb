# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/search/utils'

# Dummy class to include the tils module
class DummyApp
  include Search::Utils
  attr_accessor :clients

  def initialize(clients = [])
    @clients = clients
  end
end

RSpec.describe Search::Utils do
  let(:clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' },
      { 'id' => 3, 'full_name' => 'Johnny Depp', 'email' => 'john@example.com' },
      { 'id' => 4, 'full_name' => 'Alicia Keys', 'email' => 'alicia@example.com' },
      { 'id' => 17, 'full_name' => 'Charlotte Harris', 'email' => 'charlotte.harris@yahoo.com' },
      { 'id' => 18, 'full_name' => 'Lucas Clark', 'email' => 'lucas.clark@outlook.com' }
    ]
  end

  let(:app) { DummyApp.new(clients) }

  describe '#search_duplicate_emails' do
    it 'displays clients with duplicate emails' do
      expect { app.search_duplicate_emails(clients) }.to output(/john@example.com/).to_stdout
      expect { app.search_duplicate_emails(clients) }.to output(/Johnny Depp/).to_stdout
      expect { app.search_duplicate_emails(clients) }.to output(/John Doe/).to_stdout
    end

    it 'displays no duplicates if none found' do
      no_duplicate_clients = clients.reject { |c| c['email'] == 'john@example.com' }
      expect { app.search_duplicate_emails(no_duplicate_clients) }.to output(/No duplicate emails found/).to_stdout
    end
  end

  describe '#search_by_name' do
    it 'finds clients with matching partial name' do
      allow(app).to receive(:gets).and_return('john')
      expect { app.search_by_name(clients) }.to output(/John Doe/).to_stdout
      expect { app.search_by_name(clients) }.to output(/Johnny Depp/).to_stdout
    end

    it 'returns message when no name matches' do
      allow(app).to receive(:gets).and_return('xyz')
      expect { app.search_by_name(clients) }.to output(/No client found with name containing: xyz/).to_stdout
    end

    it 'handles mixed-case input' do
      allow(app).to receive(:gets).and_return('JoHn')
      expect { app.search_by_name(clients) }.to output(/Johnny Depp/).to_stdout
    end

    it 'returns message when empty input string' do
      allow(app).to receive(:gets).and_return('')
      expect { app.search_by_name(clients) }.to output(/Please enter a valid name./).to_stdout
    end
  end

  describe '#handle_user_option' do
    it 'handles valid options: 1 (duplicate search)' do
      expect(app).to receive(:search_duplicate_emails)
      app.handle_user_option(1, clients)
    end

    it 'handles valid options: 2 (name search)' do
      expect(app).to receive(:search_by_name)
      app.handle_user_option(2, clients)
    end

    it 'handles exit option (3)' do
      expect(app.handle_user_option(3, clients)).to be_falsey
    end

    it 'handles invalid option' do
      expect { app.handle_user_option(7, clients) }.to output(/Invalid option/).to_stdout
    end
  end

  describe '#search_continue' do
    it 'continues if input is yes' do
      allow(app).to receive(:gets).and_return('yes')
      expect(app.search_continue).to be true
    end

    it 'stops if input is no' do
      allow(app).to receive(:gets).and_return('n')
      expect(app.search_continue).to be false
    end

    it 'handles invalid input by exiting' do
      allow(app).to receive(:gets).and_return('qwerty')
      expect { app.search_continue }.to output(/Invalid input/).to_stdout
      expect(app.search_continue).to be false
    end
  end

  describe '#load_clients' do
    it 'returns empty array if file not found' do
      allow(File).to receive(:exist?).and_return(false)
      expect(app.load_clients).to eq([])
    end

    it 'loads clients if file exists' do
      file_path = File.expand_path('../../db/data/clients.json', __dir__)
      sample_data = [{ 'id' => 1, 'full_name' => 'Test', 'email' => 'test@example.com' }]
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return(sample_data.to_json)
      allow(Pathname).to receive(:new).and_return(Pathname.new(file_path))
      expect(app.load_clients.first['email']).to eq('test@example.com')
    end
  end
end
