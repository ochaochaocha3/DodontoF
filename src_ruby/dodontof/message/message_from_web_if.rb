# -*- coding: utf-8 -*-

require 'dodontof/utils'
require 'dodontof/message/abstract_message'

module DodontoF
  module Message
    # Web インターフェース経由のメッセージを表すクラス
    class MessageFromWebIf < AbstractMessage
      # JSONP のコールバック関数名
      # @return [String, nil]
      attr_reader :jsonpCallbackFuncName

      # CGI 広告埋め込み対策のマーカーを追加するか？
      # @return [Boolean]
      attr_reader :addMarker
      alias addMarker? addMarker

      # メッセージの内容が格納されている Hash の内容を利用して
      # インスタンスを生成する
      # @param [Hash] hash Web インターフェース経由のメッセージのデータ
      # @return [MessageFromWebIf]
      def self.fromHash(hash)
        # 仮引数の Hash を破壊しないように複製する
        messageData = hash.dup

        jsonpCallbackFuncName = messageData['callback']
        messageData.delete('callback')

        addMarker = !Utils.nilOrEmptyString?(messageData['marker'])
        messageData.delete('marker')

        commandName = messageData['webif']
        messageData.delete('webif')

        new(commandName,
            messageData,
            :callback => jsonpCallbackFuncName,
            :addMarker => addMarker)
      end

      # コンストラクタ
      # @param [String] commandName コマンド名
      # @param [Hash] args コマンドの引数
      # @param [Hash] options 省略可能なオプション
      # @options options [String, nil] :callback
      #   JSONP のコールバック関数名
      # @options options [Boolean] :addMarker
      #   CGI 広告埋め込み対策のマーカーを追加するか？
      def initialize(commandName, args, options = {})
        defaultOptions = {
          :callback => nil,
          :addMarker => false
        }
        mergedOptions = defaultOptions.merge(options)

        @commandName = commandName
        @args = args
        @jsonpCallbackFuncName = mergedOptions[:callback]
        @addMarker = mergedOptions[:addMarker]
      end

      # JSONP を使うか？
      def jsonp?
        !Utils.nilOrEmptyString?(@jsonpCallbackFuncName)
      end
    end
  end
end
