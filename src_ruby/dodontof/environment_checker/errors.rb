# -*- coding: utf-8 -*-

module DodontoF
  class EnvironmentChecker
    # セーブデータ用ディレクトリが見つからなかった場合のエラークラス
    class SaveDataDirNotFoundError < StandardError
      # ディレクトリのパス
      # @return [String]
      attr_reader :path

      # コンストラクタ
      # @param [String] path ディレクトリのパス
      def initialize(path)
        super("saveDataDir not found: #{path}")
        @path = path
      end
    end

    # 画像保存用ディレクトリが見つからなかった場合のエラークラス
    class ImageUploadDirNotFoundError < StandardError
      # ディレクトリのパス
      # @return [String]
      attr_reader :path

      # コンストラクタ
      # @param [String] path ディレクトリのパス
      def initialize(path)
        super("imageUploadDir not found: #{path}")
        @path = path
      end
    end

    # セーブデータ用ディレクトリに書き込めない場合のエラークラス
    class SaveDataDirNotWritableError < StandardError
      # ディレクトリのパス
      # @return [String]
      attr_reader :path

      # コンストラクタ
      # @param [String] path ディレクトリのパス
      def initialize(path)
        super("saveDataDir not writable: #{path}")
        @path = path
      end
    end

    # 画像保存用ディレクトリに書き込めない場合のエラークラス
    class ImageUploadDirNotWritableError < StandardError
      # ディレクトリのパス
      # @return [String]
      attr_reader :path

      # コンストラクタ
      # @param [String] path ディレクトリのパス
      def initialize(path)
        super("imageUploadDir not writable: #{path}")
        @path = path
      end
    end
  end
end
