# -*- coding: utf-8 -*-

require 'singleton'

module DodontoF
  module Response
    # MessagePack ライブラリ読み込み失敗応答のシングルトンクラス
    class MessagePackLoadFailureResponse
      include Singleton

      # 応答の本体
      # @return [Hash]
      attr_reader :body

      # コンストラクタ
      def initialize
        @body = {
          'warning' => { 'key' => 'youNeedInstallMsgPack' },
          'exceptionClass' => 'LoadError'
        }
      end

      # HTTP ステータスコードを返す
      # @return [Integer] 500 Internal Server Error
      def httpStatusCode
        500
      end
    end
  end
end
