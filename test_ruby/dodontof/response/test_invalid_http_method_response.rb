# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/invalid_http_method_response'

module DodontoF
  module Response
    class InvalidHttpMethodResponseTest < Test::Unit::TestCase
      def setup
        @response = InvalidHttpMethodResponse.new('HEAD')
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        # 405 Method Not Allowed
        assert_equal(405, @response.httpStatusCode)
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        expectedData = {
          'result' => 'Invalid HTTP method: HEAD'
        }
        assert_equal(expectedData, @response.body)
      end
    end
  end
end
