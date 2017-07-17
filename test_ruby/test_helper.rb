# テストヘルパー

$LOAD_PATH.unshift(File.expand_path('../src_ruby/rack/lib', File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path('../src_ruby', File.dirname(__FILE__)))

require 'test/unit'
