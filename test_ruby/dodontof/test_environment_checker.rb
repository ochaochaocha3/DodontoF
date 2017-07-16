# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'dodontof/environment_checker'

module DodontoF
  # 動作環境チェック処理のテスト
  class EnvironmentCheckerTest < Test::Unit::TestCase
    # 作業用の一時ディレクトリ
    TEMP_DIR = File.expand_path('environment_checker_temp',
                                File.dirname(__FILE__))

    def setup
      FileUtils.mkdir(TEMP_DIR)

      @saveDataDir = TEMP_DIR
      @saveDataSaveDataDir = "#{@saveDataDir}/saveData"
      @imageUploadDir = "#{TEMP_DIR}/imageUploadSpace"
      @checker = EnvironmentChecker.new(@saveDataDir, @imageUploadDir)
    end

    def teardown
      FileUtils.rm_rf(TEMP_DIR)
    end

    # 正常な動作環境の場合
    def test_checkInGoodEnvironment
      makeDirectories
      assert_equal(true, @checker.check)
    end

    # セーブデータ用ディレクトリが見つからなかった場合
    def test_saveDataDirNotFoundError
      makeDirectories
      FileUtils.rm_rf(@saveDataSaveDataDir)

      assert_raise(EnvironmentChecker::SaveDataDirNotFoundError,
                   'ディレクトリが存在しない場合') do
        @checker.check
      end

      File.open(@saveDataSaveDataDir, 'w') do |f|
        f.puts('saveData')
      end
      assert_raise(EnvironmentChecker::SaveDataDirNotFoundError,
                   'ディレクトリ以外が存在する場合') do
        @checker.check
      end
    end

    # セーブデータ用ディレクトリに書き込めなかった場合
    def test_saveDataDirNotWritableError
      makeDirectories
      setNotWritable(@saveDataSaveDataDir)

      assert_raise(EnvironmentChecker::SaveDataDirNotWritableError) do
        @checker.check
      end
    end

    # 画像保存用ディレクトリが見つからなかった場合
    def test_imageUploadDirNotFoundError
      makeDirectories
      FileUtils.rm_rf(@imageUploadDir)

      assert_raise(EnvironmentChecker::ImageUploadDirNotFoundError,
                   'ディレクトリが存在しない場合') do
        @checker.check
      end

      File.open(@imageUploadDir, 'w') do |f|
        f.puts('imageUploadDir')
      end
      assert_raise(EnvironmentChecker::ImageUploadDirNotFoundError,
                   'ディレクトリ以外が存在する場合') do
        @checker.check
      end
    end

    # 画像保存用ディレクトリに書き込めなかった場合
    def test_imageUploadDirNotWritableError
      makeDirectories
      setNotWritable(@imageUploadDir)

      assert_raise(EnvironmentChecker::ImageUploadDirNotWritableError) do
        @checker.check
      end
    end

    private

    # 必要なディレクトリを作成する
    def makeDirectories
      FileUtils.mkdir_p([@saveDataSaveDataDir, @imageUploadDir])
    end

    # 書き込み不可にする
    # @param [String] path 対象のパス
    def setNotWritable(path)
      FileUtils.chmod(0555, path)
    end
  end
end
