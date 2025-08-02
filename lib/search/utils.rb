require 'json'
require 'pathname'

module Search
  module Utils
    def display_menu
      puts "\n1. Search for duplicate emails"
      puts '2. Search by client name'
      puts '3. Exit'
      puts 'Please choose an option (1-3):'
      puts '-----------------------------------'
    end

    def load_clients
      file_path = Pathname.new(__dir__).join('../..', 'db', 'data', 'clients.json').expand_path
      return [] unless File.exist?(file_path)

      JSON.parse(File.read(file_path))
    end

    def handle_user_option(option, clients)
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

    def search_duplicate_emails(clients)
      all_emails = clients.map { |client| client['email'].downcase }
      duplicate_emails = all_emails.select { |email| all_emails.count(email) > 1 }.uniq
      return puts 'No duplicate emails found.' if duplicate_emails.empty?

      puts 'duplicates found:'
      puts duplicate_emails

      puts 'These clients have duplicate emails: '
      duplicate_emails.each do |email|
        clients_with_email = clients.select { |client| client['email'].downcase == email }
        puts "Email: #{email}"
        display_client_list(clients_with_email)
        puts '...............................................'
      end
    end

    def search_by_name(clients)
      puts 'Enter the name of client to search: '
      partial_text = gets.chomp.strip.downcase
      return puts 'Please enter a valid name.' if partial_text.empty?

      matching_names = clients.select { |client| client['full_name'].downcase.include?(partial_text) }
      return puts "No client found with name containing: #{partial_text}." if matching_names.empty?

      puts "Total clients found: #{matching_names.count}"
      display_client_list(matching_names)
    end

    def display_client_list(client_list)
      puts 'ID | Client Name           | Client Email'
      client_list.each do |client|
        puts "#{client['id']} | #{client['full_name']} | #{client['email']}"
      end
      puts '-----------------------------------'
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
end
