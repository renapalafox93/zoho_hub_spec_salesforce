# frozen_string_literal: true

require 'zoho_hub/response'
require 'zoho_hub/with_connection'
require 'zoho_hub/with_attributes'
require 'zoho_hub/string_tools'

module ZohoHub
  class BaseRecord
    include WithConnection
    include WithAttributes

    class << self
      def request_path(name = nil)
        @request_path = name if name
        @request_path ||= StringTools.pluralize(StringTools.demodulize(to_s))
        @request_path
      end

      def find(id)
        body = get(File.join(request_path, id.to_s))
        response = build_response(body)

        if response.empty?
          raise RecordNotFound, "Couldn't find #{request_path.singularize} with 'id'=#{id}"
        end

        new(response.data)
      end

      def where(params)
        path = File.join(request_path, 'search')

        response = get(path, params)
        data = response[:data]

        data.map { |info| new(info) }
      end

      def find_by(params)
        records = where(params)
        records.first
      end

      def create(params)
        new(params).save
      end

      def all(options = {})
        options[:page] ||= 1
        options[:per_page] ||= 200

        body = get(request_path, options)
        response = build_response(body)

        data = response.nil? ? [] : response.data

        data.map { |info| new(info) }
      end

      def exists?(id)
        !find(id).nil?
      rescue RecordNotFound
        false
      end

      alias exist? exists?

      def build_response(body)
        response = Response.new(body)

        raise InvalidTokenError, response.msg if response.invalid_token?
        raise RecordInvalid, response.msg if response.invalid_data?

        response
      end
    end

    def save
      body = if new_record? # create new record
               post(self.class.request_path, data: [to_params])
             else # update existing record
               path = File.join(self.class.request_path, id)
               put(path, data: [to_params])
             end

      response = build_response(body)

      response.data.dig(:details, :id)
    end

    def new_record?
      !id
    end

    def to_params
      params = {}

      attributes.each do |attr|
        key = attr_to_zoho_key(attr)

        params[key] = send(attr)
      end

      params
    end

    def build_response(body)
      self.class.build_response(body)
    end
  end
end
