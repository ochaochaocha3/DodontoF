# -*- coding: utf-8 -*-

require 'dodontof/utils'

module DodontoF
  module Message
    # メッセージの抽象クラス
    class AbstractMessage
      # コマンド名
      # @return [String, nil]
      attr_reader :commandName

      # コマンド引数のハッシュテーブル
      # @return [Hash]
      attr_reader :args

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

      # JSONP を使うか？
      # @abstract
      def jsonp?
        raise NotImplementedError,
          'method jsonp? must be overridden'
      end
    end
  end
end
