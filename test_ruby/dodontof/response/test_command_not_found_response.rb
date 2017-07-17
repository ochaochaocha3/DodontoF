# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/command_not_found_response'

module DodontoF
  module Response
    class CommandNotFoundResponseTest < Test::Unit::TestCase
      # CommandNotFoundError のモッククラス
      class MockCommandNotFoundError
        attr_reader :commandName

        def initialize(commandName)
          @commandName = commandName
        end
      end

      def setup
        @commandName = 'invalidCommand'
        @response = CommandNotFoundResponse.new(@commandName)
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        # 400 Bad Request
        assert_equal(400, @response.httpStatusCode)
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        expectedData = {
          'result' => %Q(Command "#{@commandName}" is not found.),
          'exceptionClass' => 'DodontoF::Command::CommandNotFoundError'
        }
        assert_equal(expectedData, @response.body)
      end
    end
  end
end
