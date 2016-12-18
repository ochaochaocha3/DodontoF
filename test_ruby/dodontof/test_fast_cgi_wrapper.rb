# -*- coding: utf-8 -*-

dir = File.expand_path(File.dirname(__FILE__))
loadPaths = [
  File.expand_path('..', dir), # test_ruby
  dir
]

loadPaths.each do |path|
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

if RUBY_VERSION >= '1.9.3'
  require 'fast_cgi_wrapper_test_ruby19'
end
