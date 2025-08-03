# frozen_string_literal: true

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

    def search_duplicate_emails(clients)
      all_emails = clients.map(&:email).map(&:downcase)
      duplicate_emails = all_emails.select { |email| all_emails.count(email) > 1 }.uniq
      return puts 'No duplicate emails found.' if duplicate_emails.empty?

      puts 'duplicates found:'
      puts duplicate_emails

      puts 'These clients have duplicate emails: '
      duplicate_emails.each do |email|
        clients_with_email = clients.select { |client| client.email.downcase == email }
        puts "Email: #{email}"
        display_client_list(clients_with_email)
        puts '...............................................'
      end
    end

    def search_by_name(clients)
      puts 'Enter the name of client to search: '
      partial_text = gets.chomp.strip.downcase
      return puts 'Please enter a valid name.' if partial_text.empty?

      matching_names = clients.select { |client| client.full_name.downcase.include?(partial_text) }
      return puts "No client found with name containing: #{partial_text}." if matching_names.empty?

      puts "Total clients found: #{matching_names.count}"
      display_client_list(matching_names)
    end

    def display_client_list(client_list)
      puts 'ID | Client Name           | Client Email'
      client_list.each do |client|
        puts "#{client.id} | #{client.full_name} | #{client.email}"
      end
      puts '-----------------------------------'
    end
  end
end
