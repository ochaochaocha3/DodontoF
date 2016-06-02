# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/command/command_not_found_error'
require 'dodontof/command/command_table'

module DodontoF
  module Command
    class CommandTableForTest
      include CommandTable

      def self.clearCommands
        @commands.clear
      end
    end

    class CommandTableTest < Test::Unit::TestCase
      # 1 だけ加える手続き
      INCREMENT = Proc.new do |_, args|
        { :n => args[:n] + 1 }
      end

      def setup
        CommandTableForTest.clearCommands
      end

      # 手続き型コマンド定義のテスト
      def test_defineProcCommand
        commandName = 'incrementProc'
        CommandTableForTest.defineProcCommand(commandName, &INCREMENT)
        command = CommandTableForTest.fetch(commandName)

        result = command.execute(nil, { :n => 1 })
        assert_equal({}, result)
      end

      # 関数型コマンド定義のテスト
      def test_defineFuncCommand
        commandName = 'incrementFunc'
        CommandTableForTest.defineFuncCommand(commandName, &INCREMENT)
        command = CommandTableForTest.fetch(commandName)

        result = command.execute(nil, { :n => 1 })
        assert_equal({ :n => 2 }, result)
      end

      # 存在しないコマンドを要求するとエラーが発生する
      def test_raiseErrorIfFetchNonExistentCommand
        assert_raise(CommandNotFoundError) do
          CommandTableForTest.fetch('invalidCommand')
        end
      end
    end
  end
end
