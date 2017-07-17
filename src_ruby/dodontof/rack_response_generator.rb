#--*- coding: utf-8 -*--

require 'rack'

require 'dodontof/msgpack_loader'

require 'dodontof/message'
require 'dodontof/response'

module DodontoF
  # Rack::Response 生成器
  class RackResponseGenerator
    JSON_MIME_TYPE = 'application/json'.freeze
    JAVASCRIPT_MIME_TYPE = 'application/javascript'.freeze

    HEAD = 'HEAD'.freeze
    CONTENT_TYPE = 'Content-Type'.freeze

    # HTTP メソッド
    # @return [String]
    attr_reader :httpMethod
    # 送られてきたメッセージ
    # @return [Message::AbstractMessage]
    attr_reader :message
    # 応答
    # @return [#body, #httpStatusCode]
    attr_reader :response

    # 新しいインスタンスを生成する（メッセージには NilMessage を設定する）
    # @param [String] httpMethod HTTP メソッド
    # @param [#httpStatusCode, #body] response 応答
    # @return [RackResponseGenerator]
    def self.withNilMessage(httpMethod, response)
      self.new(httpMethod,
               Message::NilMessage.instance,
               response)
    end

    # HTTP リクエスト解析結果を元にコマンドの実行を試み、
    #   Rack::Response 生成器を得る
    # @param [HttpRequestParseResult] httpRequestParseResult
    #   HTTP リクエスト解析結果
    # @param [Class] serverClass サーバーのクラス
    # @param [Class] saveDirInfoClass セーブデータ情報のクラス
    # @return [RackResponseGenerator] Rack::Response 生成器
    def self.fromHttpRequest(httpRequestParseResult, serverClass, saveDirInfoClass)
      httpMethod = httpRequestParseResult.httpMethod

      unless httpRequestParseResult.validHttpMethod?
        return self.withNilMessage(
          httpMethod,
          Response::InvalidHttpMethodResponse.new(httpMethod)
        )
      end

      if httpRequestParseResult.exception
        return self.withNilMessage(
          httpMethod,
          Response::HttpRequestParseErrorResponse.new(
            httpRequestParseResult
          )
        )
      end

      if MsgpackLoader.failed?
        return self.withNilMessage(
          httpMethod,
          Response::MessagePackLoadFailureResponse.instance
        )
      end

      # 送信元により適切なクラス・モジュールを選ぶ
      messageClass, commandTable, responseModule =
        if httpRequestParseResult.webIf?
          [Message::MessageFromWebIf,
           serverClass.webIfCommands,
           Response::WebIf]
        else
          [Message::MessageFromClient,
           serverClass.clientCommands,
           Response::Client]
        end

      message = messageClass.fromHash(httpRequestParseResult.messageData)
      unless message.commandSpecified?
        # コマンドが指定されていないため中止する
        return self.new(
          httpMethod,
          message,
          responseModule::CommandNotSpecifiedResponse.new(
            serverClass::SERVER_TYPE
          )
        )
      end

      command = commandTable[message.commandName]
      unless command
        return self.new(
          httpMethod,
          message,
          Response::CommandNotFoundResponse.new(message.commandName)
        )
      end

      begin
        server = serverClass.new(saveDirInfoClass.new, message.args)
        result = command.execute(server, message.args)
        return self.new(
          httpMethod,
          message,
          Response::SuccessResponse.new(result)
        )
      rescue Exception => e
        return self.new(
          httpMethod,
          message,
          Response::FailureResponse.new(e)
        )
      end
    end

    # コンストラクタ
    # @param [String] httpMethod HTTP メソッド
    # @param [Message::AbstractMessage] message 受信したメッセージ
    # @param [#httpStatusCode, #body] response 応答
    def initialize(httpMethod, message, response)
      @httpMethod = httpMethod
      @message = message
      @response = response
    end

    # Rack::Response を生成する
    #
    # HTTP ステータスコードはコマンド実行処理の結果による。
    #
    # レスポンスボディは基本的に JSON の文字列で、
    # Content-Type ヘッダは application/json。
    # JSONP 指定の場合関数呼び出しになり、Content-Type ヘッダは
    # application/javascript に変わる。
    #
    # @return [Rack::Response]
    def generate
      rackResponse = Rack::Response.new(
        [],
        @response.httpStatusCode,
        {}
      )

      return rackResponse if @httpMethod == HEAD

      rackResponse[CONTENT_TYPE] =
        @message.jsonp? ? JAVASCRIPT_MIME_TYPE : JSON_MIME_TYPE

      json = Utils.getJsonString(@response.body)
      body =
        if @message.jsonp?
          "#{@message.jsonpCallbackFuncName}(#{json});"
        else
          json
        end
      rackResponse.write(body)

      rackResponse
    end
  end
end
