# frozen_string_literal: true

module Mindee
  module HTTP
    # Global HTTP error module.
    module Error
      # Creates an appropriate HTTP error exception, based on retrieved http error code
      # @param url [String] the url of the product
      # @param response [Hash] dictionary response retrieved by the server
      # @param code [Integer] http error code of the response
      # @param server_error [String] potential error message to be given to the error.
      def handle_error(url, response, code: nil, server_error: nil); end

      # API HttpError
      class HttpError < StandardError
        # @return [String]
        attr_reader :api_code
        # @return [String]
        attr_reader :api_details
        # @return [String]
        attr_reader :api_message
        # @return [String]
        attr_reader :name

        def initialize(http_error, _url, code)
          @api_code = code
          @api_details = http_error['details']
          @api_message = http_error['message']
          @name = name
          super("#{@api_code}: #{@api_details} - #{@api_message}")
        end
      end

      # Generic client errors.
      # Can include errors like InvalidQuery.
      class Http400Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp400Error'
        end
      end

      # Can include errors like NoTokenSet or InvalidToken.
      class Http401Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp401Error'
        end
      end

      # Regular AccessForbidden error.
      # Can also include errors like PlanLimitReached, AsyncRequestDisallowed or SyncRequestDisallowed.
      class Http403Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp403Error'
        end
      end

      # Uncommon error.
      # Can occasionally happen when unusually large documents are passed.
      class Http413Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp413Error'
        end
      end

      # Usually corresponds to TooManyRequests errors.
      # Arises whenever too many calls to the API are made in quick succession.
      class Http429Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp429Error'
        end
      end

      # Generic server errors.
      class Http500Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp500Error'
        end
      end

      # Miscellaneous server errors.
      # Can include errors like RequestTimeout or GatewayTimeout.
      class Http504Error < HttpError
        def initialize(http_error, url, code)
          super(http_error, url, code)
          @name = 'MindeeHttp504Error'
        end
      end
    end
  end
end
