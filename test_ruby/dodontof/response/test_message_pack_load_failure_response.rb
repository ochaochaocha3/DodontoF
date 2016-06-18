# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/message_pack_load_failure_response'

module DodontoF
  module Response
    class MessagePackLoadFailureResponseTest < Test::Unit::TestCase
      def setup
        @response = MessagePackLoadFailureResponse.instance
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        # 500 Internal Server Error
        assert_equal(500, @response.httpStatusCode)
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        expectedData = {
          'warning' => { 'key' => 'youNeedInstallMsgPack' },
          'exceptionClass' => 'LoadError'
        }
        assert_equal(expectedData, @response.body)
      end
    end
  end
end
