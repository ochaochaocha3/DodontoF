#--*- coding: utf-8 -*--

require 'dodontof/message/nil_message'

module DodontoF
  # HTTP レスポンスの生成に必要な要素を表すクラス
  class HttpResponseElementSet
    # HTTP リクエストの解析結果
    # @return [HttpRequestParseResult]
    attr_reader :httpRequestParseResult
    # 送られてきたメッセージ
    # @return [Message::AbstractMessage]
    attr_reader :message
    # 応答
    # @return [#body, #httpStatusCode]
    attr_reader :response

    # 新しいインスタンスを生成する（メッセージには NilMessage を設定する）
    # @param [HttpRequestParseResult] httpRequestParseResult
    #   HTTP リクエストの解析結果
    # @param [#httpStatusCode, #body] response 応答
    # @return [HttpResponseElementSet]
    def self.withNilMessage(httpRequestParseResult, response)
      self.new(httpRequestParseResult,
               Message::NilMessage.instance,
               response)
    end

    # コンストラクタ
    # @param [HttpRequestParseResult] httpRequestParseResult
    #   HTTP リクエストの解析結果
    # @param [Message::AbstractMessage] message 受信したメッセージ
    # @param [#httpStatusCode, #body] response 応答
    def initialize(httpRequestParseResult, message, response)
      @httpRequestParseResult = httpRequestParseResult
      @message = message
      @response = response
    end
  end
end
