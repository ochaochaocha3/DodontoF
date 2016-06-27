# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/message/message_from_web_if'

module DodontoF
  module Message
    class MessageFromWebIfTest < Test::Unit::TestCase
      def setup
        @args = {
          'minRoom' => 3,
          'maxRoom' => 5
        }
        @messageData = {
          'webif' => 'getRoomList',
          'callback' => 'responseFunction'
        }.merge(@args)

        @message = MessageFromWebIf.fromHash(@messageData)
      end

      def test_jsonpCallbackFuncName
        assert_equal(@messageData['callback'], @message.jsonpCallbackFuncName)
        assert_equal(false, @message.args.has_key?('callback'))
      end

      def test_commandName
        assert_equal(@messageData['webif'], @message.commandName)
        assert_equal(false, @message.args.has_key?('webif'))
      end

      def test_args
        assert_equal(@args, @message.args)
      end

      def test_jsonp?
        messageWithNilJsonpFuncName = MessageFromWebIf.new(
          '', {}, :callback => nil
        )
        assert_equal(false,
                     messageWithNilJsonpFuncName.jsonp?,
                     'nil -> false')

        messageWithEmptyJsonpFuncName = MessageFromWebIf.new(
          '', {}, :callback => ''
        )
        assert_equal(false,
                     messageWithEmptyJsonpFuncName.jsonp?,
                     '空 -> false')

        messageWithJsonpFuncName = MessageFromWebIf.new(
          '', {}, :callback => 'responseFunction'
        )
        assert_equal(true,
                     messageWithJsonpFuncName.jsonp?,
                     '指定 -> true')
      end

      def test_commandSpecified?
        messageWithNilCommandName = MessageFromWebIf.new(nil, {})
        assert_equal(false,
                     messageWithNilCommandName.commandSpecified?,
                     'nil -> false')

        messageWithEmptyCommandName = MessageFromWebIf.new('', {})
        assert_equal(false,
                     messageWithEmptyCommandName.commandSpecified?,
                     '空 -> false')

        messageWithCommandName = MessageFromWebIf.new('getPlayRoomStates', {})
        assert_equal(true,
                     messageWithCommandName.commandSpecified?,
                     '指定 -> true')
      end
    end
  end
end
