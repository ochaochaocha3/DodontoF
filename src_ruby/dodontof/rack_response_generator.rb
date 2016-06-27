#--*- coding: utf-8 -*--

require 'dodontof/message/nil_message'

module DodontoF
  # Rack::Response 生成器
  class RackResponseGenerator
    JSON_MIME_TYPE = 'application/json'
    JAVASCRIPT_MIME_TYPE = 'application/javascript'

    CONTENT_TYPE = 'Content-Type'

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

      return rackResponse if @httpMethod == 'HEAD'

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
