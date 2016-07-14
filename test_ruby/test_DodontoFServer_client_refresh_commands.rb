# -*- coding: utf-8 -*-

$LOAD_PATH.unshift(File.expand_path('..', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('.', File.dirname(__FILE__)))

require 'test_helper'

require 'test/unit'
require 'test/unit/assertions/assert_have_keys'

# テスト用のコンフィグファイルをDodontoFServerに読みこませる
$isTestMode = true
require 'DodontoFServer.rb'
require 'server_test_impl.rb'

require 'dodontof/command/client_commands/login_commands'
require 'dodontof/command/client_commands/refresh_commands'

class DodontoFServerClientRefreshCommandsTest < Test::Unit::TestCase
  include DodontoFServerTestImpl

  def getTargetDodontoFServer
    DodontoFServer
  end

  def test_refresh
    getLoginInfoArgs = { 'params' => {} }
    serverGetLoginInfo = getDodontoFServerForTest.new(SaveDirInfo.new, {})
    getLoginInfo = DodontoF::Command::ClientCommands.fetch('getLoginInfo')
    getLoginInfoResult = getLoginInfo.execute(serverGetLoginInfo, getLoginInfoArgs)
    uniqueId = getLoginInfoResult['uniqueId']
    own = [uniqueId, 'DodontoFServerClientRefreshCommandsTest'].join("\t")

    loginPasswordArgs = {
      'room' => 0,
      'own' => own,
      'params' => {
        'roomNumber' => 0,
        'password' => 'password',
        'visiterMode' => false
      }
    }
    serverLoginPassword = getDodontoFServerForTest.new(SaveDirInfo.new, loginPasswordArgs)
    loginPassword = DodontoF::Command::ClientCommands.fetch('loginPassword')
    loginPasswordResult = loginPassword.execute(serverLoginPassword, loginPasswordArgs)

    assert_equal('OK', loginPasswordResult['resultText'])


    times_keys = [
      'map',
      'characters',
      'chatMessageDataLog',
      'time',
      'effects',
      'playRoomInfo',
      'record',
      'recordIndex'
    ]
    times_array = times_keys.map { |k| [k, 0] }
    refreshArgs = {
      'room' => 0,
      'own' => own,
      'params' => {
        'rindex' => 0,
        'name' => '名無しさん',
        'times' => Hash[times_array]
      }
    }
    serverRefresh = getDodontoFServerForTest.new(SaveDirInfo.new, refreshArgs)
    refresh = DodontoF::Command::ClientCommands.fetch('refresh')
    result = refresh.execute(serverRefresh, refreshArgs)

    assert_have_keys(
      result,
      'characters',
      'mapData', # プロトコルの説明では 'map'
      'roundTimeData', # プロトコルの説明では 'time'
      'effects',
      'playRoomName', # プロトコルの説明では 'playRoomInfo'
      'chatMessageDataLog',
      'lastUpdateTimes',
      'refreshIndex',
      'loginUserInfo',
      'isFirstChatRefresh',
      'lastUpdateTimes'
    )
    assert_equal(nil, result['warning'])
  end
end
