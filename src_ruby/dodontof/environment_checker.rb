# -*- coding: utf-8 -*-

require 'dodontof/environment_checker/errors'

module DodontoF
  # 動作環境チェック処理のクラス
  class EnvironmentChecker
    # コンストラクタ
    # @param [String] saveDataDir セーブデータ用ディレクトリのパス
    # @param [String] imageUploadDir 画像保存用ディレクトリのパス
    def initialize(saveDataDir, imageUploadDir)
      @saveDataDir = File.join(saveDataDir, 'saveData')
      @imageUploadDir = imageUploadDir
    end

    # 動作環境をチェックする
    # @return [true] 正常な動作環境だった場合
    # @raise [SaveDataDirNotFoundError]
    #   セーブデータ用ディレクトリが見つからなかった場合
    # @raise [ImageUploadDirNotFoundError]
    #   画像保存用ディレクトリが見つからなかった場合
    # @raise [SaveDataDirNotWritableError]
    #   セーブデータ用ディレクトリに書き込めなかった場合
    # @raise [ImageUploadDirNotWritableError]
    #   画像保存用ディレクトリに書き込めなかった場合
    def check
      unless File.directory?(@saveDataDir)
        raise SaveDataDirNotFoundError, @saveDataDir
      end

      unless File.directory?(@imageUploadDir)
        raise ImageUploadDirNotFoundError, @imageUploadDir
      end

      unless File.writable?(@saveDataDir)
        raise SaveDataDirNotWritableError, @saveDataDir
      end

      unless File.writable?(@imageUploadDir)
        raise ImageUploadDirNotWritableError, @imageUploadDir
      end

      # チェック成功
      true
    end
  end
end
