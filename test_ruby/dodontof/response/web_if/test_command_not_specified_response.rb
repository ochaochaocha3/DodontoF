# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('../../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('../..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'fileutils'
require 'dodontof/environment_checker'
require 'dodontof/response/web_if/command_not_specified_response'

module DodontoF
  module Response
    module WebIf
      class CommandNotSpecifiedResponseTest < Test::Unit::TestCase
        # 作業用の一時ディレクトリ
        TEMP_DIR = File.expand_path('command_not_specified_response_temp',
                                    File.dirname(__FILE__))
        # サーバーの種類を表す文字列
        SERVER_TYPE = 'どどんとふ（MySQL）'

        def setup
          # グローバル変数を退避する
          @prevGlobalSAVE_DATA_DIR = $SAVE_DATA_DIR
          @prevGlobalImageUploadDir = $imageUploadDir

          FileUtils.mkdir_p(TEMP_DIR)

          $SAVE_DATA_DIR = @saveDataDir = TEMP_DIR
          @saveDataSaveDataDir = "#{@saveDataDir}/saveData"
          $imageUploadDir = @imageUploadDir = "#{TEMP_DIR}/imageUploadSpace"
        end

        def teardown
          FileUtils.rm_rf(TEMP_DIR)

          # グローバル変数を元に戻す
          $SAVE_DATA_DIR = @prevGlobalSAVE_DATA_DIR
          $imageUploadDir = @prevGlobalImageUploadDir
        end

        # HTTP ステータスコードが正しい
        # 正常な環境
        def test_httpStatusCodeShouldBeCorrectInGoodEnvironment
          makeDirectories
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          # 200 OK
          assert_equal(200, response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        # 正常な環境
        def test_bodyShouldContainCorrectDataInGoodEnvironment
          makeDirectories
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          expectedData =
            { 'result' => "「#{SERVER_TYPE}」の動作環境は正常に起動しています。" }
          assert_equal(expectedData, response.body)
        end

        # HTTP ステータスコードが正しい
        # セーブデータ用ディレクトリが見つからなかった場合
        def test_httpStatusCodeShouldBeCorrectWhenSaveDataDirIsNotFound
          makeEnvironmentWhereSaveDataDirIsNotFound
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          # 200 OK
          assert_equal(200, response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        # セーブデータ用ディレクトリが見つからなかった場合
        def test_bodyShouldContainCorrectDataWhenSaveDataDirIsNotFound
          makeEnvironmentWhereSaveDataDirIsNotFound
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          expectedData = {
            'result' => "Error: saveData ディレクトリ (#{@saveDataSaveDataDir}) が存在しません。",
            'exceptionClass' => EnvironmentChecker::SaveDataDirNotFoundError.to_s
          }
          assert_equal(expectedData, response.body)
        end

        # HTTP ステータスコードが正しい
        # セーブデータ用ディレクトリに書き込めなかった場合
        def test_httpStatusCodeShouldBeCorrectWhenSaveDataDirIsNotWritable
          makeEnvironmentWhereSaveDataDirIsNotWritable
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          # 200 OK
          assert_equal(200, response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        # セーブデータ用ディレクトリに書き込めなかった場合
        def test_bodyShouldContainCorrectDataWhenSaveDataDirIsNotWritable
          makeEnvironmentWhereSaveDataDirIsNotWritable
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          expectedData = {
            'result' => "Error: saveData ディレクトリ (#{@saveDataSaveDataDir}) に書き込めません。",
            'exceptionClass' => EnvironmentChecker::SaveDataDirNotWritableError.to_s
          }
          assert_equal(expectedData, response.body)
        end

        # HTTP ステータスコードが正しい
        # 画像保存用ディレクトリが見つからなかった場合
        def test_httpStatusCodeShouldBeCorrectWhenImageUploadDirIsNotFound
          makeEnvironmentWhereImageUploadDirIsNotFound
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          # 200 OK
          assert_equal(200, response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        # 画像保存用ディレクトリが見つからなかった場合
        def test_bodyShouldContainCorrectDataWhenImageUploadDirIsNotFound
          makeEnvironmentWhereImageUploadDirIsNotFound
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          expectedData = {
            'result' => "Error: 画像保存用ディレクトリ (#{@imageUploadDir}) が存在しません。",
            'exceptionClass' => EnvironmentChecker::ImageUploadDirNotFoundError.to_s
          }
          assert_equal(expectedData, response.body)
        end

        # HTTP ステータスコードが正しい
        # 画像保存用ディレクトリに書き込めなかった場合
        def test_httpStatusCodeShouldBeCorrectWhenImageUploadDirIsNotWritable
          makeEnvironmentWhereImageUploadDirIsNotWritable
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          # 200 OK
          assert_equal(200, response.httpStatusCode)
        end

        # レスポンスボディには正しいデータが含まれている
        # 画像保存用ディレクトリに書き込めなかった場合
        def test_bodyShouldContainCorrectDataWhenImageUploadDirIsNotWritable
          makeEnvironmentWhereImageUploadDirIsNotWritable
          response = CommandNotSpecifiedResponse.new(SERVER_TYPE)

          expectedData = {
            'result' => "Error: 画像保存用ディレクトリ (#{@imageUploadDir}) に書き込めません。",
            'exceptionClass' => EnvironmentChecker::ImageUploadDirNotWritableError.to_s
          }
          assert_equal(expectedData, response.body)
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

        # セーブデータ用ディレクトリが存在しない環境を作る
        def makeEnvironmentWhereSaveDataDirIsNotFound
          makeDirectories
          FileUtils.rm_rf(@saveDataSaveDataDir)
        end

        # 画像保存用ディレクトリが存在しない環境を作る
        def makeEnvironmentWhereImageUploadDirIsNotFound
          makeDirectories
          FileUtils.rm_rf(@imageUploadDir)
        end

        # セーブデータ用ディレクトリに書き込めない環境を作る
        def makeEnvironmentWhereSaveDataDirIsNotWritable
          makeDirectories
          setNotWritable(@saveDataSaveDataDir)
        end

        # 画像保存用ディレクトリに書き込めない環境を作る
        def makeEnvironmentWhereImageUploadDirIsNotWritable
          makeDirectories
          setNotWritable(@imageUploadDir)
        end
      end
    end
  end
end
