# -*- coding: utf-8 -*-

require 'dodontof/logger'
require 'dodontof/command/client_commands'

module DodontoF
  module Command
    class ClientCommands
      # チャット発言コマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [void]
      defineProcCommand('sendChatMessage') do |server, args|
        chatData = args[KEY_PARAMS]
        server.logger.debug(chatData, 'chatData')

        server.sendChatMessageByChatData(chatData)
      end

      # ダイスロール時のチャット発言を行うコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('sendDiceBotChatMessage') do |server, args|
        logger = server.logger
        logger.debug('sendDiceBotChatMessage')

        params = args[KEY_PARAMS]

        repeatCount = server.getDiceBotRepeatCount(params)

        results = []

        repeatCount.times do |i|
          paramsClone = params.clone
          paramsClone['message'] += " \##{ i + 1 }" if repeatCount > 1

          result = server.sendDiceBotChatMessageOnece( paramsClone )
          logger.debug(result, "sendDiceBotChatMessageOnece result")

          next if result.nil?

          results << result
        end

        logger.debug(results, "sendDiceBotChatMessage results")

        results
      end

      # サーバの管理用に使用する、全部屋への一括メッセージ送信機能
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('sendChatMessageAll') do |server, args|
        logger = server.logger
        logger.debug("sendChatMessageAll Begin")

        result = { 'result' => "NG" }

        next result if $mentenanceModePassword.nil?
        chatData = args[KEY_PARAMS]

        password = chatData["password"]
        next result unless password == $mentenanceModePassword

        logger.debug("adminPoassword check OK.")

        rooms = []

        $saveDataMaxCount.times do |roomNumber|
          logger.debug(roomNumber, "loop roomNumber")

          server.initSaveFiles(roomNumber)

          trueSaveFileName = server.saveDirInfo.
            getTrueSaveFileName($playRoomInfo)
          next unless server.isExist?(trueSaveFileName)

          logger.debug(roomNumber, "sendChatMessageAll to No.")
          server.sendChatMessageByChatData(chatData)

          rooms << roomNumber
        end

        result['result'] = "OK"
        result['rooms'] = rooms
        logger.debug(result, "sendChatMessageAll End, result")

        result
      end

      # ログインしている部屋のチャットの全ログを削除するコマンド
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('deleteChatLog') do |server, args|
        trueSaveFileName = server.saveFiles['chatMessageDataLog']
        server.deleteChatLogBySaveFile(trueSaveFileName)

        { 'result' => "OK" }
      end
    end
  end
end
