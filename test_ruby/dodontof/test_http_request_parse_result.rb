# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/http_request_parse_result'

module DodontoF
  class HttpRequestParseResultTest < Test::Unit::TestCase
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
  end
end
