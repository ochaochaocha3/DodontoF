#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'yaml'

configFile = File.expand_path('DodontoF_fcgi_config.yml',
                              File.dirname(__FILE__))
configData = YAML.load_file(configFile)

Dir.chdir(configData['DodontoFDir'])

require './src_ruby/dodontof/fast_cgi_wrapper'

options = {
  reloadConfigFile: configData['ReloadConfigFile'],
  intervalForWatchingReloadConfigFile: configData['IntervalForWatchingReloadConfigFile'],
  logShiftAge: configData['LogShiftAge'],
  logShiftSize: configData['LogShiftSize'],
  logLevel: configData['LogLevel']
}
DodontoF::FastCgiWrapper.new(configData['LogFile'], options).execute
