# -*- coding: utf-8 -*-

require 'dodontof/message/abstract_message'

module DodontoF
  module Message
    # クライアントからのメッセージを表すクラス
    class MessageFromClient < AbstractMessage
      # メッセージの内容が格納されている Hash の内容を利用して
      # インスタンスを生成する
      # @param [Hash] hash クライアントからのメッセージのデータ
      # @return [MessageFromClient]
      def self.fromHash(hash)
        # 仮引数の Hash を破壊しないように複製する
        messageData = hash.dup

        message = self.new

        message.commandName = messageData['cmd']
        messageData.delete('cmd')

        # 残りはコマンドの引数
        message.args = messageData

        message
      end

      def initialize
        super
      end

      # CGI 広告埋め込み対策のマーカーを追加するか？
      # @return [false]
      def addMarker?
        false
      end

      # JSONP を使うか？
      # @return [false]
      def jsonp?
        false
      end
    end
  end
end
