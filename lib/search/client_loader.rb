# frozen_string_literal: true

require 'json'
require_relative 'client'

module Search
  class ClientLoader
    def initialize(file_path)
      @file_path = file_path
      @clients = load_clients
    end

    def all_clients
      @clients
    end

    private

    def load_clients
      json_data = JSON.parse(File.read(@file_path))

      clients_data = json_data.is_a?(Array) ? json_data : [json_data]

      clients_data.map do |client_data|
        Client.new(client_data)
      end
    rescue JSON::ParserError => e
      puts "Error parsing JSON file: #{e.message}"
      []
    rescue Errno::ENOENT
      puts "Error: File not found - #{@file_path}"
      []
    end
  end
end
