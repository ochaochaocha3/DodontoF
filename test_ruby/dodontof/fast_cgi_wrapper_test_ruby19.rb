# -*- coding: utf-8 -*-

require 'test_helper'

require 'test/unit'
require 'mocha/test_unit'

require 'stringio'
require 'logger'
require 'fileutils'
require 'tempfile'

require 'dodontof/fast_cgi_wrapper'

module DodontoF
  class FastCgiWrapper
    attr_writer :lastCheckOfReloadConfigFile
  end

  # どどんとふを FastCGI 環境で動作させるためのラッパークラスのテスト
  #
  # Ruby 1.9 以降限定なので、bundler でインストールされる新しい
  # test-unit の記法を導入してもよい。
  class FastCgiWrapperTest < Test::Unit::TestCase
    def teardown
      DodontoF::ConfigLoader.unstub(:load!)
      Time.unstub(:now)
      File.unstub(:exist?)
    end

    sub_test_case('initilize') do
      test('FastCGI ロガーが正しく設定される') do
        logLevel = ::Logger::DEBUG

        sio = StringIO.new
        wrapper = FastCgiWrapper.new(sio, {
          logLevel: logLevel
        })

        logger = wrapper.instance_variable_get(:@fcgiLogger)
        logdev = logger.instance_variable_get(:@logdev)

        assert_equal(sio, logdev.dev, 'ログデバイスが正しい')
        assert_equal(logLevel, wrapper.logLevel, 'ログレベルが正しい')
      end

      test('logFile が指定されなければ FastCGI ロガーは nil') do
        wrapper = FastCgiWrapper.new(nil)

        logger = wrapper.instance_variable_get(:@fcgiLogger)
        assert_nil(logger)
      end

      data(
        'reloadConfigFile の型が不正' => [
          TypeError,
          { reloadConfigFile: 12345 }
        ],
        'intervalForWatchingReloadConfigFile の型が不正' => [
          TypeError,
          { intervalForWatchingReloadConfigFile: 'Error' }
        ],
        'intervalForWatchingReloadConfigFile が正の数でない' => [
          ArgumentError,
          { intervalForWatchingReloadConfigFile: 0 }
        ]
      )
      test('無効なオプションで例外が出る') do |(exceptionClass, options)|
        assert_raise(exceptionClass) do
          FastCgiWrapper.new(nil, options)
        end
      end
    end

    test('設定の再読み込み') do
      wrapper = FastCgiWrapper.new(nil)
      assert_equal(nil, wrapper.lastConfigLoad)

      DodontoF::ConfigLoader.stubs(:load!).returns(true)
      reloadedTime = Time.new(2017, 1, 1)
      Time.stubs(:now).returns(reloadedTime)

      wrapper.send(:loadConfig!)

      assert_equal(reloadedTime, wrapper.lastConfigLoad)
    end

    sub_test_case('shouldReloadConfig?') do
      test('監視間隔が設定されていなければ false') do
        wrapper = FastCgiWrapper.new(nil, {
          intervalForWatchingReloadConfigFile: nil
        })

        assert_false(wrapper.send(:shouldReloadConfig?))
      end

      test('設定再読み込みトリガーファイルが存在しなければ false') do
        reloadConfigFile = 'reload-config-test'

        wrapper = FastCgiWrapper.new(nil, {
          reloadConfigFile: reloadConfigFile,
          intervalForWatchingReloadConfigFile: 30
        })

        File.stubs(:exist?).with(reloadConfigFile).returns(false)
        assert_false(wrapper.send(:shouldReloadConfig?))
      end

      test('監視間隔が経過していない場合は false') do
        Tempfile.open(['reload-config', '.txt']) do |t|
          wrapper = FastCgiWrapper.new(nil, {
            reloadConfigFile: t.path,
            intervalForWatchingReloadConfigFile: 10000
          })

          DodontoF::ConfigLoader.stubs(:load!).returns(true)
          wrapper.send(:loadConfig!)

          wrapper.lastCheckOfReloadConfigFile = Time.now - 1

          FileUtils.touch(t.path)

          assert_false(wrapper.send(:shouldReloadConfig?))
        end
      end

      test('トリガーファイルの最終更新が前回の設定読み込みより前ならば false') do
        Tempfile.open(['reload-config', '.txt']) do |t|
          now = Time.now
          aSecBeforeNow = now - 1
          FileUtils.touch(t.path, mtime: aSecBeforeNow)

          wrapper = FastCgiWrapper.new(nil, {
            reloadConfigFile: t.path,
            intervalForWatchingReloadConfigFile: 0.1
          })
          wrapper.lastCheckOfReloadConfigFile = aSecBeforeNow

          DodontoF::ConfigLoader.stubs(:load!).returns(true)
          wrapper.send(:loadConfig!)

          assert_false(wrapper.send(:shouldReloadConfig?))
        end
      end

      test('トリガーファイルの最終更新が前回の設定読み込みより後ならば true') do
        Tempfile.open(['reload-config', '.txt']) do |t|
          now = Time.now
          aSecBeforeNow = now - 1

          wrapper = FastCgiWrapper.new(nil, {
            reloadConfigFile: t.path,
            intervalForWatchingReloadConfigFile: 0.1
          })
          wrapper.lastCheckOfReloadConfigFile = aSecBeforeNow

          DodontoF::ConfigLoader.stubs(:load!).returns(true)
          wrapper.send(:loadConfig!)

          sleep(1)
          FileUtils.touch(t.path)

          assert_true(wrapper.send(:shouldReloadConfig?))
        end
      end

      test('トリガーファイルの最終更新が未来ならば false') do
        Tempfile.open(['reload-config', '.txt']) do |t|
          now = Time.now
          aSecBeforeNow = now - 1

          wrapper = FastCgiWrapper.new(nil, {
            reloadConfigFile: t.path,
            intervalForWatchingReloadConfigFile: 0.1
          })
          wrapper.lastCheckOfReloadConfigFile = aSecBeforeNow

          DodontoF::ConfigLoader.stubs(:load!).returns(true)
          wrapper.send(:loadConfig!)

          FileUtils.touch(t.path, mtime: Time.new(9999, 1, 1))

          assert_false(wrapper.send(:shouldReloadConfig?))
        end
      end
    end
  end
end
