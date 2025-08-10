# frozen_string_literal: true

require 'sinatra'
require 'json'

require_relative 'search/client_loader'

class SearchApi < Sinatra::Base
  configure do
    set :root, File.expand_path('../../../', __FILE__)
    @clients = Search::ClientLoader.new('db/data/clients.json').all_clients
    @available_fields = @clients.first.attributes.keys || []
  end
  class << self
    attr_reader :clients, :available_fields
  end

  get '/' do
    'Your API is running now!!'
  end

  get '/search/duplicates' do
    field = params[:field]&.downcase

    if field.nil? || field.empty?
      status 400
      return {error: 'field parameter is required.'}.to_json
    end

    unless self.class.available_fields.include?(field)
      status 400
      return {
        error: 'Invalid field.'
    }.to_json
    end

    field_values = self.class.clients.map{|client| client.send(field) rescue nil}.compact
    puts '=========='
    puts field_values
    puts '+++++++++++++++++'
    duplicate_values = field_values.select{|val| field_values.count(val) > 1}.uniq
    puts '-------------------'
    puts duplicate_values
    duplicate_clients = {}
    duplicate_values.each do |val|
      dup_clients = self.class.clients.select{|client| client.send(field) == val}.map{|client| client.to_h}
      duplicate_clients["#{val}"] = dup_clients

    end
    {
      field: field,
      duplicate_clients: duplicate_clients
  }.to_json
  end
end

if $PROGRAM_NAME == __FILE__
  SearchApi.run!
end
