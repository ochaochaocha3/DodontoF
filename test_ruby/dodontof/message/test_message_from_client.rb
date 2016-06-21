# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/message/message_from_client'

module DodontoF
  module Message
    class MessageFromClientTest < Test::Unit::TestCase
      def setup
        @args = {
          'params' => {
            'minRoom' => 0,
            'maxRoom' => 3
          }
        }
        @messageData = {
          'cmd' => 'getPlayRoomStates'
        }.merge(@args)

        @message = MessageFromClient.fromHash(@messageData)
      end

      def test_jsonpShouldReturnFalse
        assert_equal(false, @message.jsonp?)
      end

      def test_addMarkerShouldReturnFalse
        assert_equal(false, @message.addMarker?)
      end

      def test_commandName
        assert_equal(@messageData['cmd'], @message.commandName)
        assert_equal(false, @message.args.has_key?('cmd'))
      end

      def test_args
        assert_equal(@args, @message.args)
      end

      def test_commandSpecified?
        messageWithNilCommandName = MessageFromClient.new(nil, {})
        assert_equal(false,
                     messageWithNilCommandName.commandSpecified?,
                     'nil -> false')

        messageWithEmptyCommandName = MessageFromClient.new('', {})
        assert_equal(false,
                     messageWithEmptyCommandName.commandSpecified?,
                     '空 -> false')

        messageWithCommandName = MessageFromClient.new('getPlayRoomStates', {})
        assert_equal(true,
                     messageWithCommandName.commandSpecified?,
                     '指定 -> true')
      end
    end
  end
end
