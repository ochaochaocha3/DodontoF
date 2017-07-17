# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'dodontof/command/command_server'
require 'dodontof/http_request_parse_result'
require 'dodontof/response'
require 'dodontof/rack_response_generator'

module DodontoF
  class RackResponseGeneratorFromHttpRequestTest < Test::Unit::TestCase
    class MockServer
      include Command::CommandServer

      class SomeError < StandardError; end

      KEY_PARAMS = 'params'.freeze

      def initialize(*)
        # 何もしない
      end

      addFuncCommandInto(clientCommands)
      def checkRoomStatus(args)
        params = args[KEY_PARAMS]

        {
          'isRoomExist' => true,
          'roomName' => 'お試し',
          'roomNumber' => params['roomNumber'],
          'chatChannelNames' => %w(メイン 雑談),
          'canUseExternalImage' => true,
          'canVisit' => true,
          'isPasswordLocked' => false,
          'isMentenanceModeOn' => false,
          'isWelcomeMessageOn' => true
        }
      end

      addProcCommandInto(clientCommands)
      def logout(_)
        :logout
      end

      addProcCommandInto(clientCommands)
      def error(_)
        raise SomeError, 'an error occurred'
      end

      addFuncCommandInto(webIfCommands)
      def getBusyInfo(_)
        {
          'loginCount' => 123,
          'maxLoginCount' => 234,
          'version' => 'Ver.1.xx.xx(yyyy/mm/dd)',
          'result' => 'OK',
        }
      end
    end

    # 無効なHTTPメソッドの場合
    def test_execute_invalidHttpMethod
      request = HttpRequestParseResult.new('HEAD')
      rackResponseGenerator = getRackResponseGenerator(request)

      assert_kind_of(Response::InvalidHttpMethodResponse,
                     rackResponseGenerator.response)
    end

    # リクエストの解析に失敗した場合
    def test_execute_requestParseError
      request = HttpRequestParseResult.new('POST', :exception => TypeError.new)
      rackResponseGenerator = getRackResponseGenerator(request)

      assert_kind_of(Response::HttpRequestParseErrorResponse,
                     rackResponseGenerator.response)
    end

    # クライアント用関数型コマンドの実行
    def test_execute_clientFuncCommand
      request = HttpRequestParseResult.new(
        'POST',
        :webIf => false,
        :messageData => {
          'cmd' => 'checkRoomStatus',
          'params' => {
            'roomNumber' => 123,
            'adminPassword' => ''
          }
        }
      )
      rackResponseGenerator = getRackResponseGenerator(request)
      response = rackResponseGenerator.response

      assert_kind_of(Response::SuccessResponse, response)
      assert_equal(123, response.body['roomNumber'])
    end

    # クライアント用手続き型コマンドの実行
    def test_execute_clientProcCommand
      request = HttpRequestParseResult.new(
        'POST',
        :webIf => false,
        :messageData => {
          'cmd' => 'logout',
          'params' => {
            'uniqueId' => (Time.now.to_f * 1000).to_i.to_s(36)
          }
        }
      )
      rackResponseGenerator = getRackResponseGenerator(request)
      response = rackResponseGenerator.response

      assert_kind_of(Response::SuccessResponse, response)
      assert_equal({}, response.body)
    end

    # クライアント用のエラーとなるコマンドの実行
    def test_execute_clientErrorCommand
      request = HttpRequestParseResult.new(
        'POST',
        :webIf => false,
        :messageData => {
          'cmd' => 'error',
          'params' => {}
        }
      )
      rackResponseGenerator = getRackResponseGenerator(request)
      response = rackResponseGenerator.response

      assert_kind_of(Response::FailureResponse, response)
      assert_equal(MockServer::SomeError.to_s, response.body['exceptionClass'])
    end

    # Webインターフェースのコマンドの実行
    def test_execute_webIfCommandByGet
      request = HttpRequestParseResult.new(
        'GET',
        :webIf => true,
        :messageData => {
          'webif' => 'getBusyInfo'
        }
      )
      rackResponseGenerator = getRackResponseGenerator(request)
      response = rackResponseGenerator.response

      assert_kind_of(Response::SuccessResponse, response)
      assert_equal('OK', response.body['result'])
    end

    private

    # HTTPリクエストの解析結果からRack::Response生成器を得る
    # @param [HttpRequestParseResult] request HTTPリクエストの解析結果
    # @return [RackResponseGenerator]
    def getRackResponseGenerator(request)
      RackResponseGenerator.fromHttpRequest(request, MockServer, Object)
    end
  end
end
