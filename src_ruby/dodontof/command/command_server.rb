# -*- coding: utf-8 -*-

require 'dodontof/command/procedural_command'
require 'dodontof/command/functional_command'

module DodontoF
  module Command
    # コマンドを提供する機能のモジュール
    module CommandServer
      # クラスメソッドをこのモジュールにまとめる
      module ClassMethods
        # クライアント用のコマンドを格納するハッシュテーブルを返す
        # @return [Hash]
        def clientCommands
          @clientCommands
        end

        # クライアント用のコマンドを格納するハッシュテーブルを返す
        # @return [Hash]
        def webIfCommands
          @webIfCommands
        end

        # 手続き型コマンドを追加する
        # @param [Hash] commandTable 追加先のコマンドテーブル
        # @return [self]
        def addProcCommandInto(commandTable)
          @commandClass = ProceduralCommand
          @tableToAddCommand = commandTable

          self
        end

        # 関数型コマンドを追加する
        # @param [Hash] commandTable 追加先のコマンドテーブル
        # @return [Hash]
        def addFuncCommandInto(commandTable)
          @commandClass = FunctionalCommand
          @tableToAddCommand = commandTable

          self
        end

        # メソッドが追加されたときの処理
        # @param [Symbol] name メソッド名
        #
        # add*CommandIntoが事前に呼ばれていた場合、テーブルにコマンドを
        # 追加する。
        def method_added(name)
          if @commandClass && @tableToAddCommand
            nameStr = name.to_s
            @tableToAddCommand[nameStr] = @commandClass.new(nameStr)
          end

          @commandClass = nil
          @tableToAddCommand = nil
        end
      end

      # includeされたときの処理
      # @param [Class] base includeを行ったクラス
      #
      # コマンドを格納するHashを初期化し、クラスメソッドを定義する。
      def self.included(base)
        base.class_eval do
          @clientCommands ||= {}
          @webIfCommands ||= {}

          @commandClass = nil
          @tableToAddCommand = nil

          extend(ClassMethods)
        end
      end
    end
  end
end
