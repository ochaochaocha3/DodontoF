# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/config'

module DodontoF
  class ConfigTest < Test::Unit::TestCase
    # キー => グローバル変数の対応
    CONFIG_MAP = {
      :debugLog => :debug,
      :logFileName => :logFileName,
      :logFileMaxSize => :logFileMaxSize,
      :logFileMaxCount => :logFileMaxCount,
      :aboutMaxLoginCount => :aboutMaxLoginCount,
      :limitLoginCount => :limitLoginCount,
      :refreshTimeout => :refreshTimeout,
      :oldMessageTimeout => :oldMessageTimeout,
      :refreshInterval => :refreshInterval,
      :saveDataMaxCount => :saveDataMaxCount,
      :numOfPlayRoomsPerGet => :playRoomGetRangeMax,
      :graveyardLimit => :graveyardLimit,
      :saveLongChatLog => :IS_SAVE_LONG_CHAT_LOG,
      :longChatLogMaxLines => :chatMessageDataLogAllLineMax,
      :uploadImageMaxSize => :UPLOAD_IMAGE_MAX_SIZE,
      :uploadImageMaxCount => :UPLOAD_IMAGE_MAX_COUNT,
      :uploadRepalyDataMaxSize => :UPLOAD_REPALY_DATA_MAX_SIZE,
      :uploadFileMaxSize => :UPLOAD_FILE_MAX_SIZE,
      :saveDataDir => :SAVE_DATA_DIR,
      :saveDataLockFileDir => :SAVE_DATA_LOCK_FILE_DIR,
      :imageUploadDir => :imageUploadDir,
      :localUploadDirMarker => :localUploadDirMarker,
      :imageUploadDirMarker => :imageUploadDirMarker,
      :protectImagePaths => :protectImagePaths,
      :replayDataUploadDir => :replayDataUploadDir,
      :saveDataTempDir => :saveDataTempDir,
      :fileUploadDir => :fileUploadDir,
      :loginMessageFile => :loginMessageFile,
      :loginMessageBaseFile => :loginMessageBaseFile,
      :oldSaveFileDeleteSeconds => :oldSaveFileDelteSeconds,
      :loginTimeout => :loginTimeOut,
      :deletablePassedSeconds => :deletablePassedSeconds,
      :enableDiceBot => :isDiceBotOn,
      :maintenanceMode => :isMentenanceNow,
      :maintenanceModePassword => :mentenanceModePassword,
      :showWelcomeMessage => :isWelcomeMessageOn,
      :dbType => :dbType,
      :databaseHostName => :databaseHostName,
      :databaseName => :databaseName,
      :databaseUserName => :databaseUserName,
      :databasePassword => :databasePassword,
      :gzipThresholdSize => :gzipTargetSize,
      :unremovablePlayRoomNumbers => :unremovablePlayRoomNumbers,
      :unloadablePlayRoomNumbers => :unloadablePlayRoomNumbers,
      :noPasswordPlayRoomNumbers => :noPasswordPlayRoomNumbers,
      :fastCgi => :isFirstCgi,
      :modRuby => :isModRuby,
      :skinImage => :skinImage,
      :showPerformanceMonitor => :isPaformanceMonitor,
      :fps => :fps,
      :mapMaxWidth => :mapMaxWidth,
      :mapMaxHeight => :mapMaxHeigth,
      :allSaveDataMaxSize => :allSaveDataMaxSize,
      :loginCountFile => :loginCountFile,
      :canTalk => :canTalk,
      :recordMaxCount => :recordMaxCount,
      :comet => :isCommet,
      :refreshIntervalForNotComet => :refreshIntervalForNotCommet,
      :retryCountLimit => :retryCountLimit,
      :loginTimeLimitSeconds => :loginTimeLimitSecond,
      :uploadFileTimeLimitSeconds => :uploadFileTimeLimitSeconds,
      :removeOldPlayRoomLimitDays => :removeOldPlayRoomLimitDays,
      :useRecord => :isUseRecord,
      :createPlayRoomPassword => :createPlayRoomPassword,
      :isMessagePackInstalled => :isMessagePackInstalled,
      :defaultUserNames => :defaultUserNames,
      :needPasswordWhenDeletePlayRoom => :isPasswordNeedFroDeletePlayRoom,
      :drawLineCountLimit => :drawLineCountLimit,
      :logoutUrl => :logoutUrl,
      :enableMultilingualization => :isMultilingualization,
      :allowExternalImage => :canUseExternalImageModeOn,
      :characterInfoToolTipMaxWidth => :characterInfoToolTipMaxWidth,
      :characterInfoToolTipMaxHeight => :characterInfoToolTipMaxHeight,
      :askRemoveRoomWhenLogout => :isAskRemoveRoomWhenLogout,
      :showAllDiceBot => :isDisplayAllDice,
      :cardOrder => :cardOrder
    }

    def setup
      CONFIG_MAP.values.each do |var|
        eval("@prev_#{var} = $#{var}")
      end

      setDefaultConfig

      @config = Config.fromGlobalVars
    end

    def teardown
      CONFIG_MAP.values.each do |var|
        eval("$#{var} = @prev_#{var}")
      end
    end

    CONFIG_MAP.each do |method, globalVar|
      class_eval %Q{
        def test_#{method}
          assert_equal($#{globalVar}, @config.#{method})
        end
      }
    end

    private

    # 標準設定にする
    #
    # ただし標準設定が nil のものは、テスト失敗を検知できるよう
    # nil 以外に変更されている
    def setDefaultConfig
      $debug = false
      $logFileName = 'log.txt'
      $logFileMaxSize = 10485760
      $logFileMaxCount = 1
      $aboutMaxLoginCount = 30
      $limitLoginCount = 100
      $refreshTimeout = 2
      $oldMessageTimeout = 180
      $refreshInterval = 0.5
      $saveDataMaxCount = 10
      $playRoomGetRangeMax = 10
      $graveyardLimit = 30
      $IS_SAVE_LONG_CHAT_LOG = true
      $chatMessageDataLogAllLineMax = 500
      $UPLOAD_IMAGE_MAX_SIZE = 10.0
      $UPLOAD_IMAGE_MAX_COUNT = 2000
      $UPLOAD_REPALY_DATA_MAX_SIZE = 5.0
      $UPLOAD_FILE_MAX_SIZE = 10.0
      $SAVE_DATA_DIR = '../..'
      $SAVE_DATA_LOCK_FILE_DIR = ''
      $imageUploadDir = '../imageUploadSpace'
      $localUploadDirMarker = '###IMAGE_UPLOADL_SPACE###'
      $imageUploadDirMarker = '###ROOM_LOCAL_SPACE###'
      $protectImagePaths = []
      $replayDataUploadDir = './replayDataUploadSpace'
      $saveDataTempDir = './saveDataTempSpace'
      $fileUploadDir = 'fileUploadSpace'
      $loginMessageFile = 'loginMessage.html'
      $loginMessageBaseFile = 'loginMessageBase.html'
      $oldSaveFileDelteSeconds = 180
      $loginTimeOut = $refreshTimeout * 1.5 + 10
      $deletablePassedSeconds = 10
      $isDiceBotOn = true
      $mentenanceModePassword = ''
      $isWelcomeMessageOn = true
      $dbType = 'mysql'
      $databaseHostName = '127.0.0.1'
      $databaseName = 'databaseName'
      $databaseUserName = 'user'
      $databasePassword = 'password'
      $isMentenanceNow = false
      $gzipTargetSize = 0;
      $unremovablePlayRoomNumbers = [0]
      $unloadablePlayRoomNumbers = [0]
      $noPasswordPlayRoomNumbers = [0]
      $isFirstCgi = false
      $isModRuby = false
      $skinImage = '';
      $isPaformanceMonitor = false;
      $fps = 60
      $mapMaxWidth = 150
      $mapMaxHeigth = 150
      $allSaveDataMaxSize = 100.0
      $loginCountFile = 'loginCount.txt'
      $canTalk = true
      $recordMaxCount = 5
      $isCommet = true
      $refreshIntervalForNotCommet = 2.0
      $retryCountLimit = 3
      $loginTimeLimitSecond = 0
      $uploadFileTimeLimitSeconds = (1 * 60 * 60)
      $removeOldPlayRoomLimitDays = 5
      $isUseRecord = true
      $createPlayRoomPassword = ''
      $isMessagePackInstalled = false
      $defaultUserNames = []
      $isPasswordNeedFroDeletePlayRoom = true
      $drawLineCountLimit = 3000
      $logoutUrl = ''
      $isMultilingualization = true
      $canUseExternalImageModeOn = false
      $characterInfoToolTipMaxWidth = -1
      $characterInfoToolTipMaxHeight = -1
      $isAskRemoveRoomWhenLogout = true
      $isDisplayAllDice = true
      $cardOrder = 'トランプ'
      $diceBotOrder = 'ダイスボット(指定無し)'
    end
  end
end
