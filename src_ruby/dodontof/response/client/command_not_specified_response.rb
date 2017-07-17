# -*- coding: utf-8 -*-

module DodontoF
  module Response
    module Client
      # コマンドが指定されていない場合の応答のクラス
      class CommandNotSpecifiedResponse
        # 例外クラス名
        #
        # 実際にはクラスを使用していないので文字列を用意しておく。
        # @return [String]
        EXCEPTION_CLASS_STRING =
          'DodontoF::Message::MessageFromClient::CommandNotSpecifiedError'.freeze

        # 応答の本体
        # @return [Hash]
        attr_reader :body

        # コンストラクタ
        def initialize(*)
          @body = {
            'result' => "Command is not specified.",
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
end
