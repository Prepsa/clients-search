# frozen_string_literal: true

module Search
  class Client
    def initialize(attrs = {})
      @id = attrs['id']
      @full_name = attrs['full_name']
      @email = attrs['email']
    end

    attr_reader :id, :full_name, :email
  end
end
