# -*- coding: utf-8 -*-

module DodontoF
  # 設定項目リスト
  config_keys = [
    # デバッグログ出力設定
    :debugLog,
    # ログファイル名
    :logFileName,
    # ログファイルサイズ
    :logFileMaxSize,
    # ログファイルの世代管理数
    :logFileMaxCount,

    # サーバで許容できると思うログイン人数
    :aboutMaxLoginCount,
    # サーバにログインする事のできる限界人数
    :limitLoginCount,

    # サーバがデータの更新をサーバ内で定期チェックして待つ最大待機時間（秒）
    :refreshTimeout,
    # サーバの一時チャットログの保存時間上限（秒）
    :oldMessageTimeout,
    # 擬似Comet時のセーブファイル定期チェック時間（秒）
    :refreshInterval,

    # プレイルームの最大数
    :saveDataMaxCount,
    # ログイン画面で一括取得できる最大プレイルーム数
    :numOfPlayRoomsPerGet,

    # 墓場に保存されるキャラクターの最大数
    :graveyardLimit,

    # チャットの過去ログ大量保管を許可するかの設定
    :saveLongChatLog,
    # チャットログ大量保管時の保管ライン数
    :longChatLogMaxLines,

    #アップロード可能な画像ファイルのファイルサイズ上限（MB）
    :uploadImageMaxSize,
    # 保持する画像の上限数（上限を超えた場合古いものから削除）
    :uploadImageMaxCount,
    # アップロード可能なリプレイデータのファイルサイズ上限（MB）
    :uploadRepalyDataMaxSize,
    # アップロード可能な一時アップロードのファイルサイズ上限（MB）
    :uploadFileMaxSize,

    # プレイルームデータ（saveData）の相対パス
    :saveDataDir,
    # ロックファイル作成先のチューニング用
    :saveDataLockFileDir,
    # 各画像（キャラクター・マップ）の保存パス
    :imageUploadDir,

    # イメージディレクトリを示すマーカー文字列
    :localUploadDirMarker,
    # シナリオ読み込み機能用のマーカー文字列（変更してはいけません）
    :imageUploadDirMarker,

    # 削除対象から外す画像ディレクトリ名一覧
    :protectImagePaths,
    # リプレイデータの保存パス
    :replayDataUploadDir,
    # セーブデータの一時保存パス
    :saveDataTempDir,
    #ファイルアップローダーのパス
    :fileUploadDir,

    # ログイン画面に表示される「お知らせ」メッセージの定義ファイル名
    :loginMessageFile,
    # ログイン画面に表示される「更新履歴」の定義ファイル名
    :loginMessageBaseFile,

    # 古いセーブファイルの自動削除を行うかを判定するための基準経過時間（秒）
    :oldSaveFileDeleteSeconds,
    # ログアウトと判定される応答途絶時間（秒）
    :loginTimeout,
    # プレイルームを削除してもよい経過時間（秒）
    :deletablePassedSeconds,

    # ダイスボットの有効（true）、無効（false）の設定
    :enableDiceBot,
    # メンテナンスモードかどうか。サーバー更新中はtrueへ。
    :maintenanceMode,
    # メンテナンス用の管理用パスワード
    :maintenanceModePassword,

    # ログイン時メッセージを表示するか
    :showWelcomeMessage,

    # セーブデータの管理方法（nil/"mysql"）
    :dbType,
    # データベースサーバーのホスト名
    :databaseHostName,
    # データベース名
    :databaseName,
    # データベースのユーザー名
    :databaseUserName,
    # データベースのパスワード
    :databasePassword,

    # サーバの応答データをgzip圧縮する場合の閾値（単位：byte）
    :gzipThresholdSize,

    # 削除不可能なプレイルーム番号を指定
    :unremovablePlayRoomNumbers,
    # ロード不可のプレイルーム番号を指定
    :unloadablePlayRoomNumbers,
    # 上記と同様に、パスワード設定不可のプレイルーム番号を指定
    :noPasswordPlayRoomNumbers,

    # FastCGIを使用するか
    :fastCgi,
    # mod_rubyを使用するか
    :modRuby,

    # 画面に使用するスキン画像。 nil なら指定無し。
    :skinImage,
    # マップ左上に性能管理を表示するか
    :showPerformanceMonitor,
    # 画面の更新速度。nilなら従来通りFlexの初期固定値（30）のまま。
    :fps,

    # マップの横幅として設定できる最大マス数
    :mapMaxWidth,
    # マップの縦幅として設定できる最大マス数
    :mapMaxHeight,

    # 「全データロード」でアップロード可能なサイズの上限（MB）
    :allSaveDataMaxSize,

    # ログイン状況を記録するファイル
    :loginCountFile,

    # 読み上げ機能を使用するか
    :canTalk,

    # 差分記録方式で保存する保存件数
    :recordMaxCount,

    # 擬似Comet方式で通信を行うか
    :comet,
    #擬似Cometを使わない場合のクライアント側での再読み込み待ち時間
    :refreshIntervalForNotComet,
    # チャットの送信失敗時の再送上限回数
    :retryCountLimit,

    # ログインしていられる最大時間
    :loginTimeLimitSeconds,
    # 簡易アップロード機能でアップロードしたファイルの保持時間（秒）
    :uploadFileTimeLimitSeconds,
    #古いプレイルームを一括削除する時の指定日数
    :removeOldPlayRoomLimitDays,

    # キャラクターの情報を前回との差分レベルで管理するRecord方式を使うか
    :useRecord,

    # プレイルーム作成時に認証パスワードを要求するかどうか
    :createPlayRoomPassword,

    # MessagePackライブラリがインストールされているか
    :isMessagePackInstalled,

    # デフォルトで表示されるユーザー名
    :defaultUserNames,

    # 部屋削除時にパスワード入力が必要か
    :needPasswordWhenDeletePlayRoom,

    # マップにペンで書き込める最大書き込み可能量
    :drawLineCountLimit,

    # ログアウト時に飛ばされるURL
    :logoutUrl,

    # 多言語化対応を有効にするか
    :enableMultilingualization,

    # 外部画像URLの有効／無効
    :allowExternalImage,

    # キャラクターコマ「その他」情報の1行最大文字数
    :characterInfoToolTipMaxWidth,
    #キャラクターコマ「その他」情報の最大行数
    :characterInfoToolTipMaxHeight,

    # ログアウト時に他に人がいない場合、部屋の削除を質問するかどうか
    :askRemoveRoomWhenLogout,

    # src_bcdice/diceBot/ に置いてあるダイスボットを全て一覧に表示するか
    :showAllDiceBot,
    # カード初期化時に表示するカードの名前順序
    :cardOrder,
    # ダイスボット一覧に表示するダイスボットの名前順序
    :diceBotOrder
  ]

  # どどんとふの設定を格納する構造体
  Config = Struct.new(*config_keys) do
    # グローバル変数から値を取得して設定する
    # @return [DodontoF::Config]
    def self.fromGlobalVars
      config = new

      config.debugLog = $debug
      config.logFileName = $logFileName
      config.logFileMaxSize = $logFileMaxSize
      config.logFileMaxCount = $logFileMaxCount
      config.aboutMaxLoginCount = $aboutMaxLoginCount
      config.limitLoginCount = $limitLoginCount
      config.refreshTimeout = $refreshTimeout
      config.oldMessageTimeout = $oldMessageTimeout
      config.refreshInterval = $refreshInterval
      config.saveDataMaxCount = $saveDataMaxCount
      config.numOfPlayRoomsPerGet = $playRoomGetRangeMax
      config.graveyardLimit = $graveyardLimit
      config.saveLongChatLog = $IS_SAVE_LONG_CHAT_LOG
      config.longChatLogMaxLines = $chatMessageDataLogAllLineMax
      config.uploadImageMaxSize = $UPLOAD_IMAGE_MAX_SIZE
      config.uploadImageMaxCount = $UPLOAD_IMAGE_MAX_COUNT
      config.uploadRepalyDataMaxSize = $UPLOAD_REPALY_DATA_MAX_SIZE
      config.uploadFileMaxSize = $UPLOAD_FILE_MAX_SIZE
      config.saveDataDir = $SAVE_DATA_DIR
      config.saveDataLockFileDir = $SAVE_DATA_LOCK_FILE_DIR
      config.imageUploadDir = $imageUploadDir
      config.localUploadDirMarker = $localUploadDirMarker
      config.imageUploadDirMarker = $imageUploadDirMarker
      config.protectImagePaths = $protectImagePaths
      config.replayDataUploadDir = $replayDataUploadDir
      config.saveDataTempDir = $saveDataTempDir
      config.fileUploadDir = $fileUploadDir
      config.loginMessageFile = $loginMessageFile
      config.loginMessageBaseFile = $loginMessageBaseFile
      config.oldSaveFileDeleteSeconds = $oldSaveFileDelteSeconds
      config.loginTimeout = $loginTimeOut
      config.deletablePassedSeconds = $deletablePassedSeconds
      config.enableDiceBot = $isDiceBotOn
      config.maintenanceMode = $isMentenanceNow
      config.maintenanceModePassword = $mentenanceModePassword
      config.showWelcomeMessage = $isWelcomeMessageOn
      config.dbType = $dbType
      config.databaseHostName = $databaseHostName
      config.databaseName = $databaseName
      config.databaseUserName = $databaseUserName
      config.databasePassword = $databasePassword
      config.gzipThresholdSize = $gzipTargetSize
      config.unremovablePlayRoomNumbers = $unremovablePlayRoomNumbers
      config.unloadablePlayRoomNumbers = $unloadablePlayRoomNumbers
      config.noPasswordPlayRoomNumbers = $noPasswordPlayRoomNumbers
      config.fastCgi = $isFirstCgi
      config.modRuby = $isModRuby
      config.skinImage = $skinImage
      config.showPerformanceMonitor = $isPaformanceMonitor
      config.fps = $fps
      config.mapMaxWidth = $mapMaxWidth
      config.mapMaxHeight = $mapMaxHeigth
      config.allSaveDataMaxSize = $allSaveDataMaxSize
      config.loginCountFile = $loginCountFile
      config.canTalk = $canTalk
      config.recordMaxCount = $recordMaxCount
      config.comet = $isCommet
      config.refreshIntervalForNotComet = $refreshIntervalForNotCommet
      config.retryCountLimit = $retryCountLimit
      config.loginTimeLimitSeconds = $loginTimeLimitSecond
      config.uploadFileTimeLimitSeconds = $uploadFileTimeLimitSeconds
      config.removeOldPlayRoomLimitDays = $removeOldPlayRoomLimitDays
      config.useRecord = $isUseRecord
      config.createPlayRoomPassword = $createPlayRoomPassword
      config.isMessagePackInstalled = $isMessagePackInstalled
      config.defaultUserNames = $defaultUserNames
      config.needPasswordWhenDeletePlayRoom = $isPasswordNeedFroDeletePlayRoom
      config.drawLineCountLimit = $drawLineCountLimit
      config.logoutUrl = $logoutUrl
      config.enableMultilingualization = $isMultilingualization
      config.allowExternalImage = $canUseExternalImageModeOn
      config.characterInfoToolTipMaxWidth = $characterInfoToolTipMaxWidth
      config.characterInfoToolTipMaxHeight = $characterInfoToolTipMaxHeight
      config.askRemoveRoomWhenLogout = $isAskRemoveRoomWhenLogout
      config.showAllDiceBot = $isDisplayAllDice
      config.cardOrder = $cardOrder
      config.diceBotOrder = $diceBotOrder

      return config
    end
  end
end
