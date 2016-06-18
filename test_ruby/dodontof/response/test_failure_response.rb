# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/failure_response'

module DodontoF
  module Response
    class FailureResponseTest < Test::Unit::TestCase
      def setup
        @errorMessage = 'プレイルーム番号(room)を指定してください'
        @response = FailureResponse.new(ArgumentError.new(@errorMessage))
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        assert_equal(200, @response.httpStatusCode)
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        expectedData = {
          'result' => @errorMessage,
          'exceptionClass' => 'ArgumentError'
        }
        assert_equal(expectedData, @response.body)
      end
    end
  end
end
