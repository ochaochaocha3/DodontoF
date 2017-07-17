# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'rack'

require 'dodontof/utils'
require 'dodontof/http_request_parse_result'
require 'dodontof/message'
require 'dodontof/response'
require 'dodontof/rack_response_generator'

module DodontoF
  class RackResponseGeneratorTest < Test::Unit::TestCase
    JSON_MIME_TYPE = 'application/json'
    JAVASCRIPT_MIME_TYPE = 'application/javascript'

    # Message のモッククラス
    MockMessage = Struct.new(:jsonp, :jsonpCallbackFuncName) do
      alias jsonp? jsonp
    end

    # Response のモッククラス
    MockResponse = Struct.new(:httpStatusCode, :body)

    # withNilMessage で Message::NilMessage が設定されるか
    def test_withNilMessage
      nilMessage = Message::NilMessage.instance
      generator = RackResponseGenerator.withNilMessage(
        nil, nil
      )
      assert_same(nilMessage, generator.message)
    end

    # JSON レスポンスを返せるか
    def test_generateShouldReturnJsonResponse
      message = MockMessage.new(false)
      result = { 'a' => 1 }
      response = MockResponse.new(200, result)
      generator = RackResponseGenerator.new('POST', message, response)

      rackResponse = generator.generate

      assert_equal(true, rackResponse.ok?)
      assert_equal(JSON_MIME_TYPE, rackResponse.content_type)
      assert_equal(%q({"a":1}), rackResponse.body[0])
    end

    # JSONP 関数呼び出しのレスポンスを返せるか
    def test_generateShouldReturnJsonpResponse
      message = MockMessage.new(true, 'responseFunction')
      result = { 'a' => 1 }
      response = MockResponse.new(200, result)
      generator = RackResponseGenerator.new('GET', message, response)

      rackResponse = generator.generate

      assert_equal(true, rackResponse.ok?)
      assert_equal(JAVASCRIPT_MIME_TYPE, rackResponse.content_type)
      assert_equal(%q|responseFunction({"a":1});|, rackResponse.body[0])
    end

    # HEAD メソッドの場合、レスポンスボディが空
    def test_generateShouldReturnResponseWithoutBodyIfMethodIsHead
      message = MockMessage.new(false)
      result = { 'result' => 'Invalid HTTP method: HEAD' }
      response = MockResponse.new(405, result)
      generator = RackResponseGenerator.new('HEAD', message, response)

      rackResponse = generator.generate

      assert_equal(true, rackResponse.method_not_allowed?)
      assert_equal(true, rackResponse.body.empty?)
    end
  end
end
