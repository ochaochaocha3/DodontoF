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
          'callback' => 'responseFunction',
          'marker' => 'true'
        }.merge(@args)

        @message = MessageFromWebIf.fromHash(@messageData)
      end

      def test_jsonpCallbackFuncName
        assert_equal(@messageData['callback'], @message.jsonpCallbackFuncName)
        assert_equal(false, @message.args.has_key?('callback'))
      end

      def test_addMarker?
        assert_equal(true, @message.addMarker?)
        assert_equal(false, @message.args.has_key?('marker'))
      end

      def test_commandName
        assert_equal(@messageData['webif'], @message.commandName)
        assert_equal(false, @message.args.has_key?('webif'))
      end

      def test_args
        assert_equal(@args, @message.args)
      end

      def test_jsonp?
        message = MessageFromWebIf.new

        message.jsonpCallbackFuncName = nil
        assert_equal(false, message.jsonp?, 'nil -> false')

        message.jsonpCallbackFuncName = ''
        assert_equal(false, message.jsonp?, '空 -> false')

        message.jsonpCallbackFuncName = 'responseFunction'
        assert_equal(true, message.jsonp?, '指定 -> true')
      end

      def test_commandSpecified?
        message = MessageFromWebIf.new

        message.commandName = nil
        assert_equal(false, message.commandSpecified?, 'nil -> false')

        message.commandName = ''
        assert_equal(false, message.commandSpecified?, '空 -> false')

        message.commandName = 'getBusyInfo'
        assert_equal(true, message.commandSpecified?, '指定 -> true')
      end
    end
  end
end
