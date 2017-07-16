# -*- coding: utf-8 -*-

module DodontoF
  module Command
    # 関数型コマンドクラス
    #
    # この型のコマンドの実行結果は内容に依存する。
    class FunctionalCommand
      # コマンド名
      # @return [String]
      attr_reader :name

      # コンストラクタ
      # @param [String] name コマンド名
      # @param [Proc] function 値を返す手続きオブジェクト
      def initialize(name)
        @name = name
      end

      # コマンドを実行する
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash] コマンドの実行結果
      def execute(server, args)
        server.send(@name, args)
      end
    end
  end
end
