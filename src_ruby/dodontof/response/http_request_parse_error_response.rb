# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # HTTP リクエスト解析エラー応答のクラス
    class HttpRequestParseErrorResponse
      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      # @param [HttpRequestParseResult] httpRequestParseResult
      #   HTTP リクエスト解析結果
      def initialize(httpRequestParseResult)
        exception = httpRequestParseResult.exception
        @body = {
          'result' => "HTTP request parse error: #{exception.message}",
          'exceptionClass' => exception.class.to_s,
          'httpMethod' => httpRequestParseResult.httpMethod
        }
      end

      # HTTP ステータスコードを返す
      # @return [Integer] 400 Bad Request
      def httpStatusCode
        400
      end
    end
  end
end
