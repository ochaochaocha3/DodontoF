# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'rack'

$isMessagePackInstalled = false
require 'msgpack/msgpackPure'

require 'dodontof/http_request_parse_result'

module DodontoF
  class HttpRequestParseResultTest < Test::Unit::TestCase
    # MessagePack の MIME タイプ
    MESSAGE_PACK_MIME_TYPE = 'application/x-msgpack'
    # どどんとふサーバーの URL
    DODONTOF_SERVER_URL = 'http://example.net/DodontoF/DodontoFServer.rb'

    # コンストラクタのテスト
    def test_initialize
      httpMethod = 'GET'
      webIf = true
      messageData = { 'webif' => 'getBusyInfo' }
      exception = ArgumentError.new('invalid args')

      result = HttpRequestParseResult.new(httpMethod,
                                          :webIf => webIf,
                                          :messageData => messageData,
                                          :exception => exception)

      assert_equal(httpMethod, result.httpMethod, 'httpMethod が正しい')
      assert_equal(webIf, result.webIf, 'webIf が正しい')
      assert_equal(messageData, result.messageData, 'messageData が正しい')
      assert_equal(exception, result.exception, 'exception が正しい')
    end

    # コンストラクタの既定のオプションのテスト
    def test_defaultOptionsOfinitialize
      result = HttpRequestParseResult.new('GET')

      assert_equal(false, result.webIf, 'webIf の規定値が正しい')
      assert_equal({}, result.messageData, 'messageData の規定値が正しい')
      assert_equal(nil, result.exception, 'exception の規定値が正しい')
    end

    # POST は有効な HTTP メソッドと判定される
    def test_postShouldBeDeterminedAsValidMethod
      result = HttpRequestParseResult.new('POST')
      assert_equal(true, result.validHttpMethod?)
    end

    # GET は有効な HTTP メソッドと判定される
    def test_getShouldBeDeterminedAsValidMethod
      result = HttpRequestParseResult.new('GET')
      assert_equal(true, result.validHttpMethod?)
    end

    # HEAD は無効な HTTP メソッドと判定される
    def test_headShouldBeDeterminedAsInvalidMethod
      result = HttpRequestParseResult.new('HEAD')
      assert_equal(false, result.validHttpMethod?)
    end

    # HEAD リクエストの解析
    def test_fromRackRequestOfHead
      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'HEAD'
      )

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal(nil, result.exception, '例外が発生しない')
      assert_equal('HEAD', result.httpMethod, 'HTTP メソッドが正しい')
      assert_equal(false, result.validHttpMethod?, '無効な HTTP メソッド')
    end

    # クライアントから送信されたメッセージを読み取れるか
    def test_fromRackRequestWithMessageFromClient
      messageData = {
        'cmd' => 'getPlayRoomStates',
        'params' => {
          'minRoom' => 0,
          'maxRoom' => 3,
        }
      }

      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'POST',
        :input => MessagePackPure.pack(messageData)
      )
      env['CONTENT_TYPE'] = MESSAGE_PACK_MIME_TYPE

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal(nil, result.exception, '例外が発生しない')
      assert_equal('POST', result.httpMethod, 'HTTP メソッドが正しい')
      assert_equal(true, result.validHttpMethod?, '有効な HTTP メソッド')
      assert_equal(false, result.webIf?, 'WebIf ではない')
      assert_equal(messageData, result.messageData, 'メッセージデータが正しい')
    end

    # クライアントから誤った型のメッセージが送信された場合
    def test_fromRackRequestWithInvalidTypedMessageFromClient
      messageData = [
        ['cmd', 'getPlayRoomStates'],
        ['params', {
          'minRoom' => 0,
          'maxRoom' => 3,
        }]
      ]

      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'POST',
        :input => MessagePackPure.pack(messageData)
      )
      env['CONTENT_TYPE'] = MESSAGE_PACK_MIME_TYPE

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal('POST', result.httpMethod)
      assert_equal(true, result.validHttpMethod?)
      assert_equal(TypeError, result.exception.class)
    end

    # MessagePack でない内容が application/x-msgpack で送られた場合
    def test_fromRackRequestWithMessageNotMessagePackedFromClient
      messageData = 'webif=getBusyInfo'

      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'POST',
        :input => messageData
      )
      env['CONTENT_TYPE'] = MESSAGE_PACK_MIME_TYPE

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal('POST', result.httpMethod)
      assert_equal(true, result.validHttpMethod?)
      assert_equal(TypeError, result.exception.class)
    end

    # Media Type が application/x-msgpack に似ているが異なる場合
    def test_fromRackRequestOfPostWithMediaTypeLikeMsgPack
      messageData = 'webif=getBusyInfo'

      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'POST',
        :input => messageData
      )
      env['CONTENT_TYPE'] = 'application/x-msgpack!!!'

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal(nil, result.exception)
      assert_equal('POST', result.httpMethod)
      assert_equal(true, result.validHttpMethod?)
      assert_equal(true, result.webIf?)
    end

    # Web インターフェース経由、POST メソッドで
    # 送信されたメッセージを読み取れるか
    def test_fromRackRequestWithMessageFromWebIfByPost
      queryString = 'webif=getBusyInfo&webif=getRoomInfo&room=1&password=himitsu&callback=responseFunction'

      env = Rack::MockRequest.env_for(
        DODONTOF_SERVER_URL,
        :method => 'POST',
        :input => queryString
      )

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal(nil, result.exception)
      assert_equal('POST', result.httpMethod)
      assert_equal(true, result.validHttpMethod?)
      assert_equal(true, result.webIf?)

      expectedMessageData = {
        'webif' => 'getRoomInfo',
        'room' => '1',
        'password' => 'himitsu',
        'callback' => 'responseFunction'
      }
      assert_equal(expectedMessageData, result.messageData)
    end

    # Web インターフェース経由、GET メソッドで
    # 送信されたメッセージを読み取れるか
    def test_fromRackRequestWithMessageFromWebIfByGet
      queryString = 'webif=getBusyInfo&webif=getRoomInfo&room=1&password=himitsu&callback=responseFunction'

      env = Rack::MockRequest.env_for(
        "#{DODONTOF_SERVER_URL}?#{queryString}",
        :method => 'GET'
      )

      request = Rack::Request.new(env)
      result = HttpRequestParseResult.fromRackRequest(request)

      assert_equal(nil, result.exception)
      assert_equal('GET', result.httpMethod)
      assert_equal(true, result.validHttpMethod?)
      assert_equal(true, result.webIf?)

      expectedMessageData = {
        'webif' => 'getRoomInfo',
        'room' => '1',
        'password' => 'himitsu',
        'callback' => 'responseFunction'
      }
      assert_equal(expectedMessageData, result.messageData)
    end
  end
end
