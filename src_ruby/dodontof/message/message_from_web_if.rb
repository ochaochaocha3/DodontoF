# -*- coding: utf-8 -*-

require 'dodontof/utils'
require 'dodontof/message/abstract_message'

module DodontoF
  module Message
    # Web インターフェース経由のメッセージを表すクラス
    class MessageFromWebIf < AbstractMessage
      # JSONP のコールバック関数名
      # @return [String, nil]
      attr_accessor :jsonpCallbackFuncName

      # CGI 広告埋め込み対策のマーカーを追加するか？
      # @return [Boolean]
      attr_accessor :addMarker
      alias addMarker? addMarker

      # メッセージの内容が格納されている Hash の内容を利用して
      # インスタンスを生成する
      # @param [Hash] hash Web インターフェース経由のメッセージのデータ
      # @return [MessageFromWebIf]
      def self.fromHash(hash)
        # 仮引数の Hash を破壊しないように複製する
        messageData = hash.dup

        message = self.new

        message.jsonpCallbackFuncName = messageData['callback']
        messageData.delete('callback')

        message.addMarker = !Utils.nilOrEmptyString?(messageData['marker'])
        messageData.delete('marker')

        message.commandName = messageData['webif']
        messageData.delete('webif')

        # 残りはコマンドの引数
        message.args = messageData

        message
      end

      def initialize
        super

        @jsonpCallbackFuncName = nil
        @addMarker = false
      end

      # JSONP を使うか？
      def jsonp?
        !Utils.nilOrEmptyString?(@jsonpCallbackFuncName)
      end
    end
  end
end
