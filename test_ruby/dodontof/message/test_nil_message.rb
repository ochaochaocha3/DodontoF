# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/message/nil_message'

module DodontoF
  module Message
    class NilMessageTest < Test::Unit::TestCase
      def setup
        @message = NilMessage.instance
      end

      def test_jsonpShouldReturnFalse
        assert_equal(false, @message.jsonp?)
      end

      def test_addMarkerShouldReturnFalse
        assert_equal(false, @message.addMarker?)
      end

      def test_commandNameShouldBeEmpty
        assert_equal(true, @message.commandName.empty?)
      end

      def test_argsShouldBeEmpty
        assert_equal({}, @message.args)
      end

      def test_commandSpecifiedShouldBeFalse
        assert_equal(false, @message.commandSpecified?)
      end
    end
  end
end
