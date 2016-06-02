# -*- coding: utf-8 -*-

require 'dodontof/command/procedural_command'
require 'dodontof/command/functional_command'
require 'dodontof/command/command_not_found_error'

module DodontoF
  module Command
    # コマンドを管理するテーブルの機能を提供するモジュール
    module CommandTable
      # include されたときの処理
      #
      # コマンドを格納する Hash を初期化し、クラスメソッドを定義する。
      # @param [Class] base include を行ったクラス
      def self.included(base)
        base.class_eval do
          @commands ||= {}

          extend(CommandTable)
        end
      end

      # 手続き型コマンドを定義する
      # @param [String] name コマンド名
      # @param [Proc] handler コマンド実行時の処理
      # @return [ProceduralCommand] 定義したコマンド
      # @raise [ArgumentError] ブロックが与えられなかった場合
      def defineProcCommand(name, &handler)
        raise ArgumentError, 'block required' unless handler

        @commands[name] = ProceduralCommand.new(name, handler)
      end

      # 関数型コマンドを定義する
      # @param [String] name コマンド名
      # @param [Proc] handler コマンド実行時の処理
      # @return [FunctionalCommand] 定義したコマンド
      # @raise [ArgumentError] ブロックが与えられなかった場合
      def defineFuncCommand(name, &handler)
        raise ArgumentError, 'block required' unless handler

        @commands[name] = FunctionalCommand.new(name, handler)
      end

      # コマンドを返す
      # @param [String] name コマンド名
      # @return [#name, #execute] 指定された名前のコマンド
      # @raise [CommandNotFoundError]
      #   指定された名前のコマンドが定義されていなかったときに発生する
      def fetch(name)
        raise CommandNotFoundError, name unless @commands.has_key?(name)

        @commands.fetch(name)
      end
    end
  end
end
