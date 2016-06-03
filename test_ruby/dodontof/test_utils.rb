# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'

require 'dodontof/utils'

require 'fileutils'

module DodontoF
  # ユーティリティメソッドのテスト
  class UtilsTest < Test::Unit::TestCase
    def teardown
      FileUtils.rm_rf('./.temp')
    end

    # getJsonString は JSON 文字列を返す
    def test_getJsonStringShouldReturnJsonString
      assert_equal('[1,2,3]',
                   Utils.getJsonString([1, 2, 3]),
                   '配列を渡した場合')
      assert_equal('{"a":1}',
                   Utils.getJsonString({ 'a' => 1 }),
                   'ハッシュを渡した場合')
    end

    # getObjectFromJsonString は JSON 文字列から変換されたオブジェクトを返す
    def test_getObjectFromJsonStringShouldReturnObject
      assert_equal([1, 2, 3],
                   Utils.getObjectFromJsonString('[1,2,3]'),
                   '配列を表す JSON 文字列を渡した場合')
      assert_equal({ 'a' => 1 },
                   Utils.getObjectFromJsonString('{"a":1}'),
                   'オブジェクトを表す JSON 文字列を渡した場合')
    end

    # makeDir は 適当なディレクトリをその場に「存在する状態」にする
    # この時他にファイルがあれば上書きする
    def test_makeDir
      # そういうディレクトリを構成しておく
      FileUtils.mkdir_p('./.temp')
      open('./.temp/makeDirTest', 'w') { |f| f.puts 'test' }

      Utils.makeDir('.temp/makeDirTest')

      assert_equal(true, File.exist?('./.temp/makeDirTest'))
      assert_equal(true, File.directory?('./.temp/makeDirTest'))
    end

    # rmdir は指定したディレクトリを削除する
    def test_rmdir
      # そういうディレクトリを構成しておく
      FileUtils.mkdir_p('./.temp/test')
      assert_equal(true, File.exist?('./.temp/test'))

      Utils.rmdir('.temp/test')

      assert_equal(true, File.exist?('./.temp/'))
      assert_equal(false, File.exist?('./.temp/test'))
    end

    # getLanguageKeyはキー値に対して何らかのラッピングを施す
    # (ラップキーが適切についているか？というのを検査するのは
    # ただのChangeDetectorになるので避けた)
    def test_getLanguageKey
      # LanguageKeyはキー値を何らかの形でラップしたものであるはずだから
      # 少なくとも指定したキーとマッチする部分列があるはずだ
      assert_match(/test/, Utils.getLanguageKey('test'))
    end

    # データサイズの許容判定
    def test_tooLargeSizeInMb?
      data = 'a' * 2000

      assert_equal(false, Utils.tooLargeSizeInMb?(data, 0.005),
                   '許容範囲内の場合')
      assert_equal(true, Utils.tooLargeSizeInMb?(data, 0.001),
                   '大きすぎる場合')
    end

    # ファイルサイズが大きすぎた場合のエラーメッセージ
    def test_tooLargeSizeMessage
      assert_equal('ファイルサイズが最大値(10MB)以上のためアップロードに失敗しました。',
                   Utils.tooLargeFileSizeMessage(10), '10 MB')
      assert_equal('ファイルサイズが最大値(5MB)以上のためアップロードに失敗しました。',
                   Utils.tooLargeFileSizeMessage(5), '5 MB')
    end
  end
end
