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

class DodontoFServerClientLoginCommandsTest < Test::Unit::TestCase
  include DodontoFServerTestImpl

  def getTargetDodontoFServer
    DodontoFServer
  end

  def test_getLoginInfo
    args = { 'params' => {} }
    server = getDodontoFServerForTest.new(SaveDirInfo.new, args)
    command = DodontoF::Command::ClientCommands.fetch('getLoginInfo')
    result = command.execute(server, args)

    assert_have_keys(
      result,
      'loginMessage',
      'cardInfos',
      'isDiceBotOn',
      'uniqueId',
      'refreshTimeout',
      'refreshInterval',
      'isCommet',
      'version',
      'playRoomMaxNumber',
      'warning',
      'playRoomGetRangeMax',
      'allLoginCount',
      'limitLoginCount',
      'loginUserCountList',
      'maxLoginCount',
      'skinImage',
      'isPaformanceMonitor',
      'fps',
      'loginTimeLimitSecond',
      'removeOldPlayRoomLimitDays',
      'canTalk',
      'retryCountLimit',
      'imageUploadDirInfo',
      'mapMaxWidth',
      'mapMaxHeigth',
      'diceBotInfos',
      'isNeedCreatePassword',
      'defaultUserNames',
      'drawLineCountLimit',
      'logoutUrl',
      'languages',
      'canUseExternalImageModeOn',
      'characterInfoToolTipMax',
      'isAskRemoveRoomWhenLogout'
    )

    assert_equal(nil, result['warning'])
  end

  def test_getLoginInfoMentenanceWarning
    backup = $isMentenanceNow
    $isMentenanceNow = true

    args = { 'params' => {} }
    server = getDodontoFServerForTest.new(SaveDirInfo.new, args)
    command = DodontoF::Command::ClientCommands.fetch('getLoginInfo')
    result = command.execute(server, args)

    warning = result['warning']
    assert_have_keys(warning, 'key')
    assert_equal('canNotLoginBecauseMentenanceNow', warning['key'])
  ensure
    $isMentenanceNow = backup
  end

  def test_getLoginInfoNoSmallImageDirWarning
    saveDirInfo = SaveDirInfo.new
    args = { 'params' => {} }
    server = getDodontoFServerForTest.new(saveDirInfo, args)
    image = DodontoF::Image.new(server, saveDirInfo)
    target = image.getSmallImageDir
    FileUtils.rm_r(target)

    command = DodontoF::Command::ClientCommands.fetch('getLoginInfo')
    result = command.execute(server, args)

    warning = result['warning']
    assert_have_keys(warning, 'key', 'params')
    assert_equal('noSmallImageDir', warning['key'])
    assert_equal([target], warning['params'], '配列に必要なディレクトリが返ってくる')
  end

  def test_checkRoomStatus
    args = {
      'params' => {
        'roomNumber' => 1
      }
    }
    server = getDodontoFServerForTest.new(SaveDirInfo.new, args)
    command = DodontoF::Command::ClientCommands.fetch('checkRoomStatus')
    result = command.execute(server, args)

    assert_have_keys(result,
                     'isRoomExist',
                     'roomName',
                     'roomNumber',
                     'chatChannelNames',
                     'canUseExternalImage',
                     'canVisit',
                     'isPasswordLocked',
                     'isMentenanceModeOn',
                     'isWelcomeMessageOn')
  end

  def test_loginPassword
    uniqueId = getUniqueId
    own = ownForTest(uniqueId)
    loginPasswordResult = doLoginPassword(own)

    assert_equal('OK', loginPasswordResult['resultText'])
    assert_equal(0, loginPasswordResult['roomNumber'])
    assert_equal(false, loginPasswordResult['visiterMode'])
  end

  def test_logout
    uniqueId = getUniqueId
    own = ownForTest(uniqueId)
    loginPasswordResult = doLoginPassword(own)

    assert_equal('OK', loginPasswordResult['resultText'])

    logoutArgs = {
      'room' => 0,
      'own' => own,
      'params' => {
        'uniqueId' => uniqueId
      }
    }
    serverLogout = getDodontoFServerForTest.new(SaveDirInfo.new, logoutArgs)
    logout = DodontoF::Command::ClientCommands.fetch('logout')
    logoutResult = logout.execute(serverLogout, logoutArgs)
    assert_equal({}, logoutResult)
  end

  private

  # ログインし、uniqueId を返す
  def getUniqueId
    getLoginInfoArgs = { 'params' => {} }
    serverGetLoginInfo = getDodontoFServerForTest.new(SaveDirInfo.new, getLoginInfoArgs)
    getLoginInfo = DodontoF::Command::ClientCommands.fetch('getLoginInfo')
    result = getLoginInfo.execute(serverGetLoginInfo, getLoginInfoArgs)

    result['uniqueId']
  end

  # テスト用の own を返す
  def ownForTest(uniqueId)
    [uniqueId, 'DodontoFServerClientLoginCommandsTest'].join("\t")
  end

  # loginPassword を実行する
  def doLoginPassword(own)
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

    loginPassword.execute(serverLoginPassword, loginPasswordArgs)
  end
end
