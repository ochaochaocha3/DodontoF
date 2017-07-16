# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/http_request_parse_result'
require 'dodontof/response/http_request_parse_error_response'

module DodontoF
  module Response
    class HttpRequestParseErrorResponseTest < Test::Unit::TestCase
      def setup
        @errorMessage = 'Message data must be a Map in MessagePack.'
        @exception = TypeError.new(@errorMessage)
        @httpRequestParseResult = HttpRequestParseResult.new(
          'POST',
          :webIf => false,
          :exception => @exception
        )

        @response =
          HttpRequestParseErrorResponse.new(@httpRequestParseResult)
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        # 400 Bad Request
        assert_equal(400, @response.httpStatusCode)
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        expectedData = {
          'result' => "HTTP request parse error: #{@errorMessage}",
          'exceptionClass' => 'TypeError',
          'httpMethod' => 'POST'
        }
        assert_equal(expectedData, @response.body)
      end
    end
  end
end
