# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/search/utils'
require_relative '../../../lib/search/client'

# Dummy class to include the utils module
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
    ].map do |attrs|
      Search::Client.new(attrs)
    end
  end

  let(:app) { DummyApp.new(clients) }

  describe '#search_duplicate_emails' do
    it 'displays clients with duplicate emails' do
      expect { app.search_duplicate_emails(clients) }.to output(/john@example.com/).to_stdout
      expect { app.search_duplicate_emails(clients) }.to output(/Johnny Depp/).to_stdout
      expect { app.search_duplicate_emails(clients) }.to output(/John Doe/).to_stdout
    end

    it 'displays no duplicates if none found' do
      no_duplicate_clients = clients.reject { |c| c.email == 'john@example.com' }
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
end
