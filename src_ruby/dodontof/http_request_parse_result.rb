# -*- coding: utf-8 -*-

require 'dodontof/msgpack_loader'

module DodontoF
  # HTTP リクエストの解析結果を表すクラス
  class HttpRequestParseResult
    # MessagePack の MIME タイプ
    MESSAGE_PACK_MIME_TYPE = 'application/x-msgpack'

    # HTTP メソッド
    # @return [String]
    attr_reader :httpMethod
    # Web インターフェース経由か？
    # @return [Boolean]
    attr_reader :webIf
    alias webIf? webIf
    # メッセージデータ
    # @return [Hash]
    attr_reader :messageData
    # 解析時に発生した例外
    # @return [Exception, nil]
    attr_reader :exception

    # Rack::Request を解析する
    # @param [Rack::Request] request 受信したリクエスト
    # @return [HttpRequestParseResult] 解析結果
    def self.fromRackRequest(request)
      httpMethod = request.request_method
      begin
        case httpMethod
        when 'POST'
          return parsePostRequest(request)
        when 'GET'
          return new('GET',
                     :webIf => true,
                     :messageData => request.params)
        else
          # 無効な HTTP メソッドだった場合
          return new(httpMethod)
        end
      rescue => e
        return new(httpMethod, :exception => e)
      end
    end

    # POST メソッドで送信された HTTP リクエストを解析する
    # @param [Rack::Request] request 受信したリクエスト
    # @return [HttpRequestParseResult]
    # @raise [TypeError] Content-Type ヘッダが application/x-msgpack
    #   でかつ受信したデータが MessagePack の Map でなかった場合
    def self.parsePostRequest(request)
      unless request.media_type == MESSAGE_PACK_MIME_TYPE
        return new('POST',
                   :webIf => true,
                   :messageData => request.params)
      end

      messageData = MessagePack.unpack(request.body.read)
      unless messageData.kind_of?(Hash)
        raise TypeError, 'Message data must be a Map in MessagePack.'
      end

      return new('POST',
                 :webIf => false,
                 :messageData => messageData)
    end
    private_class_method :parsePostRequest

    # コンストラクタ
    # @param [String] httpMethod HTTP メソッド
    # @param [Hash] options 省略可能なオプション
    # @option options [Boolean] :webIf Web インターフェース経由か？
    # @option options [Hash] :messageData メッセージデータ
    # @option options [Exception, nil] :exception 解析時に発生した例外
    def initialize(httpMethod, options = {})
      defaultOptions = {
        :webIf => false,
        :messageData => {},
        :exception => nil
      }
      mergedOptions = defaultOptions.merge(options)

      @httpMethod = httpMethod
      @webIf = mergedOptions[:webIf]
      @messageData = mergedOptions[:messageData]
      @exception = mergedOptions[:exception]
    end

    # 有効な HTTP メソッドか？
    # @return [true] HTTP メソッドが POST か GET の場合
    # @return [false] HTTP メソッドが POST でも GET でもない場合
    def validHttpMethod?
      @httpMethod == 'POST' || @httpMethod == 'GET'
    end
  end
end
