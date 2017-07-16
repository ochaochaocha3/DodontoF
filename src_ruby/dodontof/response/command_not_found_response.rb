# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # コマンドが見つからなかった場合の応答のクラス
    class CommandNotFoundResponse
      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      def initialize(exception)
        @body = {
          'result' => %Q(Command "#{exception.commandName}" is not found.),
          'exceptionClass' => exception.class.to_s
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
