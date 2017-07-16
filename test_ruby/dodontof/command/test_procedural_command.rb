# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/command/procedural_command'

module DodontoF
  module Command
    class ProceduralCommandTest < Test::Unit::TestCase
      def setup
        @command = ProceduralCommand.new(:increment)
      end

      # 名前が正しい
      def test_nameShouldBeCorrect
        assert_equal(:increment, @command.name)
      end

      # 実行すると空の Hash を返す
      def test_executeShouldReturnEmptyHash
        server = Object.new
        def server.increment(args)
          { :n => args[:n] + 1 }
        end

        result = @command.execute(server, { :n => 1 })
        assert_equal({}, result)
      end
    end
  end
end
