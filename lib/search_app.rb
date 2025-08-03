# frozen_string_literal: true

# Search for emails in a file
# By: Prepsa Kayastha

require_relative 'search/utils'
require_relative 'search/client_loader'

class SearchApp
  include Search::Utils

  attr_reader :clients
  def self.run
    new.search_clients
  end

  def initialize
    @clients = Search::ClientLoader.new('db/data/clients.json').all_clients
  end

  def search_clients
    puts "Welcome to 'Client Search App'"
    return puts 'No clients data found.' if clients.empty?

    loop do
      display_menu
      option = gets.chomp.to_i
      break unless handle_user_option(option)

      break unless search_continue
    end
  end

  private

  def handle_user_option(option)
    case option
    when 1
      puts 'Searching for duplicate emails....'
      puts '-----------------------------------'
      search_duplicate_emails(clients)
    when 2
      puts 'You chose to search clients by name.'
      puts '-----------------------------------'
      search_by_name(clients)
    when 3
      puts 'Exiting the program. Goodbye!'
      return false
    else
      puts 'Invalid option. Please try again.'
    end
    true
  end

  def search_continue
    puts 'Do you want to perform another search? (yes/no)'
    user_answer = gets.chomp.strip.downcase
    if %w[yes y].include?(user_answer)
      puts 'Continuing with the next search...'
      puts '-----------------------------------'
      true
    elsif %w[no n].include?(user_answer)
      puts 'Exiting the app. Goodbye!'
      false
    else
      puts 'Invalid input. Exiting the app.'
      false
    end
  end
end
