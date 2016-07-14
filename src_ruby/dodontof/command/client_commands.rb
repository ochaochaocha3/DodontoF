# -*- coding: utf-8 -*-

require 'dodontof/command/command_table'

module DodontoF
  module Command
    # クライアント用のコマンドを格納するクラス
    class ClientCommands
      include CommandTable

      KEY_PARAMS = 'params'
    end
  end
end
