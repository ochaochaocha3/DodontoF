# -*- coding: utf-8 -*-

module DodontoF
  module Response
    # コマンドが見つからなかった場合の応答のクラス
    class CommandNotFoundResponse
      # 例外クラス名
      #
      # 実際にはクラスを使用していないので文字列を用意しておく。
      # @return [String]
      EXCEPTION_CLASS_STRING = 'DodontoF::Command::CommandNotFoundError'

      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      def initialize(commandName)
        @body = {
          'result' => %Q(Command "#{commandName}" is not found.),
          'exceptionClass' => EXCEPTION_CLASS_STRING
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
