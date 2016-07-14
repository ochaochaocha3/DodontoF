# -*- coding: utf-8 -*-

require 'dodontof/command/client_commands'

module DodontoF
  module Command
    class ClientCommands
      # サーバから部屋の各種情報を定期的に取得するためのコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('refresh') do |server, args|
        logger = server.logger
        logger.debug("==>Begin refresh");

        saveData = {}

        if $isMentenanceNow
          saveData["warning"] = {"key" => "canNotRefreshBecauseMentenanceNow", "params" => []}
        end

        params = args[KEY_PARAMS]
        logger.debug(params, "params")

        server.lastUpdateTimes = params['times']
        logger.debug(server.lastUpdateTimes, "server.lastUpdateTimes")

        isFirstChatRefresh = (server.lastUpdateTimes['chatMessageDataLog'] == 0)
        logger.debug(isFirstChatRefresh, "isFirstChatRefresh")

        refreshIndex = params['rIndex']
        logger.debug(refreshIndex, "refreshIndex")

        server.isGetOwnRecord = params['isGetOwnRecord'];

        if $isCommet
          server.refreshLoop(saveData)
        else
          server.refreshOnce(saveData)
        end

        uniqueId = server.getCommandSenderFromArgs(args)
        loginUserInfo = server.getLoginUserInfo(params['name'],
                                                uniqueId,
                                                params['isVisiter'])

        unless saveData.empty?
          saveData['lastUpdateTimes'] = server.lastUpdateTimes
          saveData['refreshIndex'] = refreshIndex
          saveData['loginUserInfo'] = loginUserInfo
        end

        if isFirstChatRefresh
          saveData['isFirstChatRefresh'] = isFirstChatRefresh
        end

        logger.debug(saveData, "refresh end saveData")
        logger.debug("==>End refresh")

        saveData
      end
    end
  end
end
