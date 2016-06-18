# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # コマンド実行失敗応答のクラス
    class FailureResponse
      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      # @param [Exception] exception 発生した例外
      def initialize(exception)
        @body = {
          'result' => exception.message,
          'exceptionClass' => exception.class.to_s
        }
      end

      # HTTP ステータスコードを返す
      # @return [Integer] 200 OK
      def httpStatusCode
        200
      end
    end
  end
end
