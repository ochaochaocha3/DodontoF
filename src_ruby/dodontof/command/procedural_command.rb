# -*- coding: utf-8 -*-

module DodontoF
  module Command
    # 手続き型コマンドクラス
    #
    # この型のコマンドの実行結果は必ず空の Hash になる。
    class ProceduralCommand
      # コマンド名
      # @return [String]
      attr_reader :name

      # コンストラクタ
      # @param [Symbol] name コマンド名
      # @param [Proc] procedure 手続き
      def initialize(name)
        @name = name
      end

      # コマンドを実行する
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash] 空の Hash
      def execute(server, args)
        server.send(@name, args)
        return {}
      end
    end
  end
end
