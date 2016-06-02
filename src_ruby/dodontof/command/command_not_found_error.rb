# -*- coding: utf-8 -*-

module DodontoF
  module Command
    class CommandNotFoundError < StandardError
      # 指定されたコマンド名
      # @return [String]
      attr_reader :commandName

      # コンストラクタ
      # @param [String] commandName 指定されたコマンド名
      def initialize(commandName)
        @commandName = commandName
        super(%Q(command "#{commandName}" is not found))
      end
    end
  end
end
