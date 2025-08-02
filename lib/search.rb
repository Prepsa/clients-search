# frozen_string_literal: true

# Search for emails in a file
# By: Prepsa Kayastha
require 'json'
require 'pathname'
module Search
  class Runner
    def self.run
      new.search_emails
    end

    def search_emails
      puts "Welcome to 'Email Search!'"

      file_path = Pathname.new(__dir__).join('..', 'db', 'data', 'clients.json').expand_path
      @client_lists = JSON.parse(File.read(file_path))

      search_run = true
      while search_run
        puts "1. Search for duplicate emails\n2. Search by partial name match\n3. Exit"
        puts 'Please choose an option (1-3): '
        puts '-----------------------------------'

        option = gets.chomp.to_i
        case option
        when 1
          puts 'You chose to search for duplicate emails.'
          puts '-----------------------------------'
          search_for_duplicate_emails
        when 2
          puts 'You chose to search by partial email match.'
          puts 'You can search for emails that contain a specific text.'
          puts '-----------------------------------'
          search_by_partial_name_match
        when 3
          puts 'Exiting the program. Goodbye!'
          search_run = false
        else
          puts 'Invalid option. Please try again.'
        end
        puts '-----------------------------------'
        puts 'Do you want to perform another search? (yes/no)'
        continue = gets.chomp.strip.downcase
        if %w[no n].include?(continue)
          puts 'Exiting the program. Goodbye!'
          search_run = false
        elsif continue != 'yes' && continue != 'y'
          puts 'Invalid input. Exiting the program.'
          search_run = false
        else
          puts 'Continuing with the next search...'
          puts '-----------------------------------'
        end
      end
    end

    def search_for_duplicate_emails
      all_emails = @client_lists.map { |client| client['email'].downcase }
      duplicate_emails = all_emails.select { |email| all_emails.count(email) > 1 }.uniq
      return puts 'No duplicate emails found.' if duplicate_emails.empty?

      puts 'duplicates found:'
      puts duplicate_emails

      puts 'These clients have duplicate emails: '
      duplicate_emails.each do |email|
        clients_with_email = @client_lists.select { |client| client['email'].downcase == email }
        puts "Email: #{email}"
        puts 'ID | Client Name           | Client Email'
        clients_with_email.each do |client|
          puts "#{client['id']} | #{client['full_name']} | #{client['email']}"
        end
      end
    end

    def search_by_partial_name_match
      puts 'Enter the text to search for in names: '
      partial_text = gets.chomp.strip.downcase

      matching_names = @client_lists.select { |client| client['full_name'].downcase.include?(partial_text) }
      return puts "No client found with name containing: #{partial_text}." if matching_names.empty?

      puts "Client with name containing: '#{partial_text}' found in the client list:"
      puts 'ID | Client Name           | Client Email'
      matching_names.each do |client|
        puts "#{client['id']} | #{client['full_name']} | #{client['email']}"
      end
    end
  end
end
