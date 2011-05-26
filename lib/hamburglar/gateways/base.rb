module Hamburglar
  module Gateways
    # Hamburglar::Gateways::Base is the main class that handles sending API
    # requests to upstream providers. All other gateways should inherit from
    # this class
    class Base

      URL_REGEX = /https?:\/\/[\S]+/

      # The parameters for the API request
      attr_reader :params

      # Errors returned when validating or submitting a request
      attr_reader :errors

      # Response returned by an API call
      attr_reader :response

      def initialize(params = {})
        @params   = params
        @errors   = {}
        @response = {}
      end

      # Get or set required parameters for this report
      def self.required_params(*params)
        if params.size > 0
          @required_params = params
        else
          @required_params ||= []
        end
      end

      # Get or set the API URL for the gateway
      def self.api_url(url = nil)
        if url
          if url.match URL_REGEX
            @api_url = url
          else
            raise Hamburglar::InvalidURL, url
          end
        else
          @api_url ||= ""
        end
      end

      # Validate presence of required_params
      #
      # Returns false if a parameter isn't set
      def validate
        @errors[:missing_parameters] = []
        self.class.required_params.each do |req|
          unless @params.has_key?(req)
            @errors[:missing_parameters] << @param
          end
        end
        @errors[:missing_parameters].empty?
      end

      # Validate presence of required_params
      #
      # Raises Hamburglar::InvalidRequest if validation fails
      def validate!
        validate || raise(Hamburglar::InvalidRequest)
      end

      # Submit a request upstream to generate a fraud report
      def submit!
        if Hamburglar.gateway.nil?
          raise Hamburglar::InvalidGateway
        end

        unless validate
          return false
        end

        # Code to perform HTTP Request here
      end

      # Parses raw data returned from an API call
      #
      # This method should be overwritten by any API subclasses that
      # return data in a different format
      #
      # Returns [Hash]
      def parse_response(raw = '')
        data = raw.to_s.split(';').map do |line|
          key, val = line.split('=')
          if key.to_s != "" && val.to_s != ""
            [key.to_sym, val]
          else
            next
          end
        end
        Hash[data]
      end

    end
  end
end
