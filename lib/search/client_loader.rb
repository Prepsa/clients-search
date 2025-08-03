# frozen_string_literal: true

require 'json'
require_relative 'client'

module Search
  class ClientLoader
    def initialize(file_path)
      @clients = JSON.parse(File.read(file_path)).map do |attrs|
        Search::Client.new(attrs)
      end
    end

    def all_clients
      @clients
    end
  end
end
