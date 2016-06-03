# -*- coding: utf-8 -*-

require 'logger'
require 'singleton'
require 'kconv'

module DodontoF
  # どどんとふ共通ロガー
  class Logger
    include Singleton

    # 標準ログデバイス
    # 事故で CGI 出力を汚さないように標準エラー出力にする
    DEFAULT_LOGDEV = $stderr
    # 標準ログ保持数
    DEFAULT_SHIFT_AGE = 0
    # 標準ログファイルサイズ
    DEFAULT_SHIFT_SIZE = 4096

    # どどんとふの設定
    @@config = nil

    # どどんとふの設定を使うよう設定する
    # @param [DodontoF::Config] config 使用する設定
    def self.config=(config)
      @@config = config
    end

    # コンストラクタ
    def initialize
      if @@config
        reset(@@config.logFileName,
              @@config.logFileMaxCount,
              @@config.logFileMaxSize)
        updateLevel(@@config.modRuby, @@config.debugLog)
      else
        reset(DEFAULT_LOGDEV, DEFAULT_SHIFT_AGE, DEFAULT_SHIFT_SIZE)
        updateLevel(false, false)
      end
    end

    # ロガーを作り直す
    # @param [String, IO] logdev ログデバイス
    # @param [Integer, String] shiftAge 保持する古いログファイルの数
    #   またはローテーション頻度
    # @param [Integer] shiftSize 最大ログファイルサイズ
    # @return [self]
    def reset(logdev, shiftAge, shiftSize)
      @logger = ::Logger.new(logdev, shiftAge, shiftSize)
      self
    end

    # ログレベルを返す
    def level
      @logger.level
    end

    # ログレベルを更新する
    # @param [Boolean] modRuby modRuby を使用しているかどうか
    # @param [Boolean] debug デバッグログ出力を行うかどうか
    # @return [self]
    def updateLevel(modRuby, debug)
      @logger.level =
        if modRuby
          ::Logger::FATAL
        else
          debug ? ::Logger::DEBUG : ::Logger::ERROR
        end

      self
    end

    # デバッグログ出力を行う
    # @param [Object] obj 対象オブジェクト
    # @param [Object] headers ヘッダ
    # @return [self]
    def debug(obj, *headers)
      # ブロックは遅延評価されるのでフィルターする必要はない
      @logger.debug { logMessage(obj, headers) }
      self
    end

    # エラーログ出力を行う
    # @param [Object] obj 対象オブジェクト
    # @param [Object] headers ヘッダ
    # @return [self]
    def error(obj, *headers)
      # ブロックは遅延評価されるのでフィルターする必要はない
      @logger.error { logMessage(obj, headers) }
      self
    end

    # 例外ログ出力を行う
    # @param [Exception] e 例外オブジェクト
    # @return [self]
    def exception(e)
      error(e.to_s, 'exception mean')

      unless $!.nil?
        error($!.backtrace.join("\n"), 'exception from')
        error($!.inspect, '$!.inspect')
      end

      self
    end

    # 簡潔に例外ログ出力を行う
    # @param [Exception] e 例外オブジェクト
    # @return [self]
    def exceptionConcisely(e)
      error($!.inspect) unless $!.nil?
      error(e.inspect)

      self
    end

    private

    # ログのメッセージを返す
    # @param [Object] obj 対象オブジェクト
    # @param [Array] headers ヘッダ
    def logMessage(obj, headers)
      message = obj.instance_of?(String) ? obj : obj.inspect.tosjis

      "#{headers.join(',')}:#{message}"
    end
  end
end
