# -*- coding: utf-8 -*-

require 'singleton'
require 'dodontof/message/abstract_message'

module DodontoF
  module Message
    # メッセージの NULL オブジェクトを表すシングルトンクラス
    class NilMessage < AbstractMessage
      include Singleton

      # インスタンスを生成する
      # @return [NilMessage]
      def self.fromHash(*)
        self.new
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
