# frozen_string_literal: true

# Search for emails in a file
# By: Prepsa Kayastha

require_relative 'search/utils'

module Search
  class App
    include Utils

    def self.run
      new.search_clients
    end

    def initialize
      @clients = load_clients
    end

    def search_clients
      puts "Welcome to 'Client Search App'"
      return puts 'No clients data found.' if @clients.empty?

      loop do
        display_menu
        option = gets.chomp.to_i
        break unless handle_user_option(option)

        break unless search_continue
      end
    end
  end
end
