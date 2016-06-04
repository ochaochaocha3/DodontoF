# -*- coding: utf-8 -*-

require 'test/unit'

module Test::Unit::Assertions
  # +hash+ のキーに +keys+ がすべて存在することを表明する
  def assert_have_keys(hash, *keys)
    keys.each do |k|
      assert_equal(true, hash.has_key?(k), %Q(キー "#{k}" が存在する))
    end
  end
end
