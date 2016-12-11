# -*- coding: utf-8 -*-

module DodontoF
  # 設定読み込み処理
  class ConfigLoader
    # 設定読み込み失敗の例外
    # @return [Exception, nil]
    @configLoadError = nil

    # ローカル設定読み込み失敗の例外
    # @return [Exception, nil]
    @configLocalLoadError = nil

    # 設定を読み込む
    # @return [true] 正常に設定が読み込まれた場合
    # @return [false] 正常に設定が読み込まれなかった場合
    def self.load!
      success = true

      @configLoadError = nil
      @configLocalLoadError = nil

      srcRuby = File.expand_path('..', File.dirname(__FILE__))

      begin
        load "#{srcRuby}/config.rb"
      rescue Exception => configLoadError
        success = false
        @configLoadError = configLoadError
      end

      begin
        load "#{srcRuby}/config_local.rb"
      rescue LoadError
        # config_local.rb がないのはエラーではないので無視する
      rescue Exception => configLocalLoadError
        success = false
        @configLocalLoadError = configLocalLoadError
      end

      load 'config_test.rb' if $isTestMode

      $loginCountFileFullPath ||= File.join($SAVE_DATA_DIR,
                                            'saveData',
                                            $loginCountFile)
      $saveFileNames = File.join($saveDataTempDir, 'saveFileNames.json')

      success
    end

    # 設定読み込みエラーのメッセージを返す
    # @return [String, nil]
    def self.errorMessage
      configRbLoadErrorMessage =
        errorMessageFrom('config.rb', @configLoadError)
      configLocalRbLoadErrorMessage =
        errorMessageFrom('config_local.rb', @configLocalLoadError)
      messages =
        [configRbLoadErrorMessage, configLocalRbLoadErrorMessage].compact

      messages.empty? ? nil : messages.join("\n\n")
    end

    # 読み込みエラーのメッセージを返す
    # @return [String, nil]
    def self.errorMessageFrom(filename, exception)
      return nil unless exception

      lines = [
        "#{filename} is invalid!",
        '',
        exception.message,
        "Exception from: #{exception.backtrace.join("\n")}",
        "Exception#inspect: #{exception.inspect}"
      ]
      lines.join("\n")
    end
    private_class_method :errorMessageFrom
  end
end
