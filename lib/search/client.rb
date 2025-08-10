# frozen_string_literal: true

module Search
  class Client
    def initialize(attrs = {})
      # @id = attrs['id']
      # @full_name = attrs['full_name']
      # @email = attrs['email']
      @attributes = attrs.dup
      @attributes.transform_keys!(&:to_s)
    end

    def method_missing(name, *args, &block)
      attribute = name.to_s
      if @attributes.key?(attribute)
        @attributes[attribute]
      else
        super
      end
    end

    def attributes
      @attributes.dup
    end

    def respond_to_missing?(name, include_private = false)
      @attributes.key?(name.to_s) || super
    end
    # attr_reader :id, :full_name, :email

    def to_h
      @attributes
    end
  end
end
