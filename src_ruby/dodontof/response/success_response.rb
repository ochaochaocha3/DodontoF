# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # コマンド実行成功応答のクラス
    class SuccessResponse
      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      # @param [Hash] content 応答の内容
      def initialize(content)
        @body = content
      end

      # HTTP ステータスコードを返す
      # @return [Integer] 200 OK
      def httpStatusCode
        200
      end
    end
  end
end
