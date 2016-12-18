# -*- coding: utf-8 -*-

require 'fcgi'
require 'logger'

require_relative '../../DodontoFServer'

module DodontoF
  # どどんとふを FastCGI 環境で動作させるためのラッパークラス
  class FastCgiWrapper
    # 設定再読み込みのトリガーとなるファイルのパス
    # @return [String, nil]
    attr_reader :reloadConfigFile
    # 設定再読み込みのトリガーとなるファイルの監視間隔（秒）
    # @return [Numeric, nil]
    attr_reader :intervalForWatchingReloadConfigFile
    # 最後に設定再読み込みトリガーファイルを監視した日時
    # @return [Time, nil]
    attr_reader :lastCheckOfReloadConfigFile
    # 最後にどどんとふの設定を読み込んだ日時
    # @return [Time, nil]
    attr_reader :lastConfigLoad

    # コンストラクタ
    # @param [String, IO] logdev ログを書き込むファイル名か IO オブジェクト
    # @param [Hash] options ログ記録のオプション
    # @option options [String, nil] :reloadConfigFile
    #   設定再読み込みのトリガーとなるファイルのパス
    # @option options [Integer, nil] :intervalForWatchingReloadConfigFile
    #   設定再読み込みのトリガーとなるファイルの監視間隔（秒）
    # @option options [Integer, String] :logShiftAge
    #   ログファイル保持数か切り替え頻度
    # @option options [Integer] :logShiftSize ログファイルを切り替えるサイズ
    # @option options [Integer] :logLevel ログレベル
    def initialize(logdev, options = {})
      defaultOptions = {
        reloadConfigFile: nil,
        intervalForWatchingReloadConfigFile: nil,
        logShiftAge: 0,
        logShiftSize: 1048576,
        logLevel: ::Logger::WARN
      }
      mergedOptions = defaultOptions.merge(options)

      @logdev = logdev
      @logShiftAge = mergedOptions[:logShiftAge]
      @logShiftSize = mergedOptions[:logShiftSize]
      @logLevel = mergedOptions[:logLevel]

      @fcgiLogger = newLogger

      @reloadConfigFile = mergedOptions[:reloadConfigFile]
      @intervalForWatchingReloadConfigFile =
        mergedOptions[:intervalForWatchingReloadConfigFile]

      begin
        checkOptions
      rescue => e
        @fcgiLogger.fatal(e) if @fcgiLogger
        raise e
      end

      @lastCheckOfReloadConfigFile = nil
      @lastConfigLoad = nil
    end

    # FastCGI ロガーのログレベルを返す
    # @return [Integer] FastCGI ロガーが設定されていた場合、ログレベルを返す
    # @return [nil] FastCGI ロガーが設定されていない場合
    def logLevel
      @fcgiLogger && @fcgiLogger.level
    end

    # どどんとふを FastCGI 環境で実行する
    def execute
      @fcgiLogger.info('FastCgiWrapper#execute') if @fcgiLogger

      loadConfig!
      @lastCheckOfReloadConfigFile = Time.now

      FCGI.each do |fcgi|
        @fcgiLogger.debug('Received a request.') if @fcgiLogger

        begin
          if shouldReloadConfig?
            loadConfig!
            @fcgiLogger.warn('Reloaded configurations.') if @fcgiLogger
          end

          $stdout = fcgi.out
          $stdin = fcgi.in
          ENV.replace(fcgi.env)

          executeDodontoServerCgi

          fcgi.finish
        rescue Exception => e
          @fcgiLogger.fatal(e) if @fcgiLogger
        end
      end

      @fcgiLogger.info('FastCgiWrapper#execute end') if @fcgiLogger
    end

    private

    # 新しいロガーを返す
    # @return [Logger]
    # @return [nil] @logdev が nil の場合
    def newLogger
      return nil unless @logdev

      logger = ::Logger.new(@logdev, @logShiftAge, @logShiftSize)
      logger.level = @logLevel

      logger
    end

    # 設定が有効か調べる
    # @return [true] 設定が有効だった場合
    # @raise [TypeError, ArgumentError]
    def checkOptions
      if @reloadConfigFile
        unless @reloadConfigFile.kind_of?(String)
          raise TypeError, 'reloadConfigFile must be a String or null'
        end
      end

      if @intervalForWatchingReloadConfigFile
        unless @intervalForWatchingReloadConfigFile.kind_of?(Numeric)
          raise TypeError,
            'intervalForWatchingReloadConfigFile must be a Numeric or null'
        end

        unless @intervalForWatchingReloadConfigFile > 0
          raise ArgumentError,
            'intervalForWatchingReloadConfigFile must be greater than 0'
        end
      end

      true
    end

    # どどんとふの設定を読み込む
    # @return [self]
    def loadConfig!
      DodontoF::ConfigLoader.load!
      @lastConfigLoad = Time.now

      self
    end

    # どどんとふの設定を再読み込みするべきかどうかを返す
    # @return [Boolean]
    def shouldReloadConfig?
      # 適切に設定されていなければ常に false
      return false unless @intervalForWatchingReloadConfigFile
      return false unless @reloadConfigFile

      if @lastCheckOfReloadConfigFile
        nextCheckTime = @lastCheckOfReloadConfigFile +
          @intervalForWatchingReloadConfigFile

        # 監視間隔だけ経過していなければ false
        return false if Time.now < nextCheckTime
      end

      result = catch(:stopCheck) do
        begin
          throw(:stopCheck, false) unless File.exist?(@reloadConfigFile)

          mtime = File.mtime(@reloadConfigFile)

          # 最終更新日時が未来だと設定を読み込み続ける可能性があるので
          # false
          throw(:stopCheck, false) if mtime > Time.now

          unless File.mtime(@reloadConfigFile) > @lastConfigLoad
            throw(:stopCheck, false)
          end

          true
        ensure
          @lastCheckOfReloadConfigFile = Time.now
        end
      end

      result
    end
  end
end
