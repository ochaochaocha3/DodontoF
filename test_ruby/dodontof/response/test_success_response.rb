# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/response/success_response'

module DodontoF
  module Response
    class SuccessResponseTest < Test::Unit::TestCase
      def setup
        @getPlayRoomStatesResult = {
          'minRoom' => 0,
          'maxRoom' => 3,
          'playRoomStates' => []
        }
        @getPlayRoomStatesResponse = SuccessResponse.new(@getPlayRoomStatesResult)

        @getBusyInfoResult = {
          'maxLoginCount' => 30,
          'loginCount' => 0,
          'version' => 'Ver.1.xx.xx(20xx/xx/xx)',
          'result' => 'OK'
        }
        @getBusyInfoResponse = SuccessResponse.new(@getBusyInfoResult)
      end

      # HTTP ステータスコードが正しい
      def test_httpStatusCodeShouldBeCorrect
        assert_equal(200, @getPlayRoomStatesResponse.httpStatusCode, 'getPlayRoomStates')
        assert_equal(200, @getBusyInfoResponse.httpStatusCode, 'getBusyInfo')
      end

      # レスポンスボディには正しいデータが含まれている
      def test_bodyShouldContainCorrectData
        assert_equal(@getPlayRoomStatesResult, @getPlayRoomStatesResponse.body,
                     'getPlayRoomStates')
        assert_equal(@getBusyInfoResult, @getBusyInfoResponse.body, 'getBusyInfo')
      end
    end
  end
end
