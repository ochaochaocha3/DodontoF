# -*- coding: utf-8 -*-

require 'dodontof/command/client_commands'

module DodontoF
  module Command
    class ClientCommands
      # ログイン画面で必要な情報を得るコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('getLoginInfo') do |server, _|
        logger = server.logger
        logger.debug("getLoginInfo begin")

        allLoginCount, loginUserCountList = server.getAllLoginCount
        server.writeAllLoginInfo(allLoginCount)

        loginMessage = server.getLoginMessage
        cardInfos = server.
          getCardsInfo.
          collectCardTypeAndTypeName($cardOrder)
        diceBotInfos = server.getDiceBotInfos

        result = {
          "loginMessage" => loginMessage,
          "cardInfos" => cardInfos,
          "isDiceBotOn" => $isDiceBotOn,
          "uniqueId" => server.createUniqueId,
          "refreshTimeout" => $refreshTimeout,
          "refreshInterval" => server.getRefreshInterval,
          "isCommet" => $isCommet,
          "version" => DodontoF::FULL_VERSION_STRING,
          "playRoomMaxNumber" => ($saveDataMaxCount - 1),
          "warning" => server.getLoginWarning,
          "playRoomGetRangeMax" => $playRoomGetRangeMax,
          "allLoginCount" => allLoginCount.to_i,
          "limitLoginCount" => $limitLoginCount,
          "loginUserCountList" => loginUserCountList,
          "maxLoginCount" => $aboutMaxLoginCount.to_i,
          "skinImage" => $skinImage,
          "isPaformanceMonitor" => $isPaformanceMonitor,
          "fps" => $fps,
          "loginTimeLimitSecond" => $loginTimeLimitSecond,
          "removeOldPlayRoomLimitDays" => $removeOldPlayRoomLimitDays,
          "canTalk" => $canTalk,
          "retryCountLimit" => $retryCountLimit,
          "imageUploadDirInfo" => {$localUploadDirMarker => $imageUploadDir},
          "mapMaxWidth" => $mapMaxWidth,
          "mapMaxHeigth" => $mapMaxHeigth,
          'diceBotInfos' => diceBotInfos,
          'isNeedCreatePassword' => (not $createPlayRoomPassword.empty?),
          'defaultUserNames' => $defaultUserNames,
          'drawLineCountLimit' => $drawLineCountLimit,
          'logoutUrl' => $logoutUrl,
          'languages' => server.getLanguages,
          'canUseExternalImageModeOn' => $canUseExternalImageModeOn,
          'characterInfoToolTipMax' => [$characterInfoToolTipMaxWidth, $characterInfoToolTipMaxHeight],
          'isAskRemoveRoomWhenLogout' => $isAskRemoveRoomWhenLogout,
          'wordChecker' => $wordChecker,
          'errorMessage' => $globalErrorMessage,
        }

        logger.debug(result, "result")
        logger.debug("getLoginInfo end")

        result
      end

      # 部屋の生成・変更前に各部屋の詳細情報を取得するコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('checkRoomStatus') do |server, args|
        server.deleteOldUploadFile

        params = args[KEY_PARAMS]
        server.logger.debug(params, 'params')

        DodontoF::PlayRoom.new(server, server.saveDirInfo).check(params)
      end

      # パスワードが定義されている部屋にログインするためのパスワードチェックコマンド
      # @param [Object] server どどんとふサーバー
      # @param [Hash] args コマンドの引数
      # @return [Hash]
      defineFuncCommand('loginPassword') do |server, args|
        loginData = args[KEY_PARAMS]
        server.logger.debug(loginData, 'loginData')

        server.checkLoginPassword(loginData['roomNumber'],
                                  loginData['password'],
                                  loginData['visiterMode'])
      end

      # サーバからログアウトするコマンド
      # @param [Hash] args コマンドの引数
      # @return [void]
      defineProcCommand('logout') do |server, args|
        logger = server.logger

        logoutData = server.getParamsFromRequestData
        logger.debug(logoutData, 'logoutData')

        uniqueId = logoutData['uniqueId']
        logger.debug(uniqueId, 'uniqueId');

        trueSaveFileName = server.saveDirInfo.
          getTrueSaveFileName($loginUserInfo)
        server.changeSaveData(trueSaveFileName) do |saveData|
          saveData.each do |existUserId, userInfo|
            logger.debug(existUserId, "existUserId in logout check")
            logger.debug(uniqueId, 'uniqueId in logout check')

            if existUserId == uniqueId
              userInfo['isLogout'] = true
            end
          end

          logger.debug(saveData, 'saveData in logout')
        end
      end
    end
  end
end
