# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/message/nil_message'
require 'dodontof/http_response_element_set'

module DodontoF
  class HttpResponseElementSetTest < Test::Unit::TestCase
    def test_withNilMessage
      nilMessage = Message::NilMessage.instance
      httpResponseElementSet = HttpResponseElementSet.withNilMessage(
        nil, nil
      )
      assert_same(nilMessage, httpResponseElementSet.message)
    end
  end
end
