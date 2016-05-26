# -*- coding: utf-8 -*-

module DodontoF
  # HTTP リクエストの解析結果を表すクラス
  class HttpRequestParseResult
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
