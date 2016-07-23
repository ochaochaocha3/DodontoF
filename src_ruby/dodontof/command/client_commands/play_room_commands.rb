# -*- coding: utf-8 -*-

require 'dodontof/command/client_commands'
require 'dodontof/play_room'

module DodontoF
  module Command
    class ClientCommands
      # 部屋の作成コマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('createPlayRoom') do |server, args|
        DodontoF::PlayRoom.new(server, server.saveDirInfo).
          create(args[KEY_PARAMS])
      end

      # 部屋の情報変更コマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('changePlayRoom') do |server, args|
        DodontoF::PlayRoom.new(server, server.saveDirInfo).
          change(args[KEY_PARAMS])
      end

      # 複数の部屋の情報を一括で取得するコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('getPlayRoomStates') do |server, args|
        DodontoF::PlayRoom.new(server, server.saveDirInfo).
          getStatesByParams(args[KEY_PARAMS])
      end

      # 部屋の削除コマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('getPlayRoomStates') do |server, args|
        DodontoF::PlayRoom.new(server, server.saveDirInfo).
          remove(args[KEY_PARAMS])
      end

      # 古い部屋の一括削除コマンド
      # @param [Object] server どどんとふサーバー
      # @return [Hash]
      defineFuncCommand('removeOldPlayRoom') do |server, _|
        DodontoF::PlayRoom.new(server, server.saveDirInfo).removeOlds
      end
    end
  end
end
