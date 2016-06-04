# -*- coding: utf-8 -*-
# テスト時用の設定群

$TEST_TEMP_ROOT = File.expand_path('.temp', File.dirname(__FILE__))
$logFileName = "#{$TEST_TEMP_ROOT}/test_log.txt"
$SAVE_DATA_DIR = "#{$TEST_TEMP_ROOT}/save"
$SAVE_DATA_LOCK_FILE_DIR = nil
$imageUploadDir = "#{$TEST_TEMP_ROOT}/imageUploadSpace"
$replayDataUploadDir = "#{$TEST_TEMP_ROOT}/replayDataUploadSpace"
$saveDataTempDir = "#{$TEST_TEMP_ROOT}/saveDataTempSpace"
$fileUploadDir = "#{$TEST_TEMP_ROOT}/fileUploadSpace"

# 環境に依存しないようにするため gem の msgpack は使わない
$isMessagePackInstalled = false
