# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # 無効な HTTP メソッドの場合の応答のクラス
    class InvalidHttpMethodResponse
      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      # @param [String] httpMethod HTTP メソッド
      def initialize(httpMethod)
        @body = {
          'result' => "Invalid HTTP method: #{httpMethod}"
        }
      end

      # HTTP ステータスコードを返す
      # @return [Integer] 405 Method Not Allowed
      def httpStatusCode
        405
      end
    end
  end
end
