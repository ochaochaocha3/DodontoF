# -*- coding: utf-8 -*-

require 'dodontof/utils'

module DodontoF
  module Message
    # メッセージの抽象クラス
    class AbstractMessage
      # コマンド名
      # @return [String, nil]
      attr_accessor :commandName

      # コマンド引数のハッシュテーブル
      # @return [Hash]
      attr_accessor :args

      # メッセージの内容が格納されている Hash の内容を利用して
      #    インスタンスを生成する
      # @abstract
      # @return [AbstractMessage]
      def self.fromHash(*)
        raise NotImplementedError,
          'class method fromHash must be overridden'
      end

      def initialize
        @commandName = ''
        @args = {}
      end

      # コマンドが指定されているか？
      def commandSpecified?
        !Utils.nilOrEmptyString?(@commandName)
      end

      # CGI 広告埋め込み対策のマーカーを追加するか？
      # @abstract
      def addMarker?
        raise NotImplementedError,
          'method addMarker? must be overridden'
      end

      # JSONP を使うか？
      # @abstract
      def jsonp?
        raise NotImplementedError,
          'method jsonp? must be overridden'
      end
    end
  end
end
