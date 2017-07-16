# -*- coding: utf-8 -*-

require 'dodontof/environment_checker'

module DodontoF
  module Response
    module WebIf
      # コマンドが指定されていない場合の応答のクラス
      class CommandNotSpecifiedResponse
        # エラーメッセージを返す手続きの集合
        # @return [Hash<StandardError, Proc>]
        ERROR_MESSAGE_PROCS = {
          EnvironmentChecker::SaveDataDirNotFoundError => lambda { |e|
            "Error: saveData ディレクトリ (#{e.path}) が存在しません。"
          },
          EnvironmentChecker::ImageUploadDirNotFoundError => lambda { |e|
            "Error: 画像保存用ディレクトリ (#{e.path}) が存在しません。"
          },
          EnvironmentChecker::SaveDataDirNotWritableError => lambda { |e|
            "Error: saveData ディレクトリ (#{e.path}) に書き込めません。"
          },
          EnvironmentChecker::ImageUploadDirNotWritableError => lambda { |e|
            "Error: 画像保存用ディレクトリ (#{e.path}) に書き込めません。"
          }
        }

        # コンストラクタ
        # @param [String] serverType
        #   サーバーの種類（MySQL 版等）を表す文字列
        def initialize(serverType)
          @serverType = serverType

          @errorMessageProcs = ERROR_MESSAGE_PROCS.dup
          @errorMessageProcs.default = lambda do |e|
            "「#{serverType}」の動作環境に問題があります: #{e}"
          end

          @environmentChecker = EnvironmentChecker.new($SAVE_DATA_DIR,
                                                       $imageUploadDir)
        end

        # 応答の本体
        # @return [Hash]
        def body
          @environmentChecker.check
          return {
            'result' => "「#{@serverType}」の動作環境は正常に起動しています。"
          }
        rescue => e
          return {
            'result' => @errorMessageProcs[e.class].call(e),
            'exceptionClass' => e.class.to_s
          }
        end

        # HTTP ステータスコードを返す
        # @return [Integer] 200 OK
        def httpStatusCode
          200
        end
      end
    end
  end
end
