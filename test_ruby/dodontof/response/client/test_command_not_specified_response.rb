# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/client/command_not_specified_response'

module DodontoF
  module Response
    module Client
      class CommandNotSpecifiedResponseTest < Test::Unit::TestCase
        def setup
          @response = CommandNotSpecifiedResponse.new('どどんとふ')
        end

        # HTTP ステータスコードが正しい
        def test_httpStatusCodeShouldBeCorrect
          # 400 Bad Request
          assert_equal(400, @response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        def test_bodyShouldContainCorrectData
          expectedData = {
            'result' => 'Command is not specified.',
            'exceptionClass' => 'DodontoF::Message::MessageFromClient::CommandNotSpecifiedError'
          }
          assert_equal(expectedData, @response.body)
        end
      end
    end
  end
end
