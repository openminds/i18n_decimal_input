require 'test/unit'
require 'rubygems'
require 'i18n'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/object/blank'
require 'i18n_decimal_input'

class Product # ActiveRecord mock
  attr_reader :price
  
  def price=(price)
    @price = convert_number_column_value(price)
  end
  
  def convert_number_column_value(value)
    value
  end
  
  include I18nDecimalInput
end

I18n.config.backend.store_translations 'nl-BE', {:number => {:format => {:delimiter => ' ', :separator => ','}}}
I18n.config.backend.store_translations 'en',    {:number => {:format => {:delimiter => ',', :separator => '.'}}}

class TestI18nDecimalInput < Test::Unit::TestCase
  def test_internationalizing_field
    I18n.with_locale("nl-BE") do
      p = Product.new
      p.price = "1 001,21"
      assert_equal "1001.21", p.price.to_s
    end
    
    I18n.with_locale("en") do
      p = Product.new
      p.price = "1,001.21"
      assert_equal "1001.21", p.price.to_s
    end
  end
  
  def test_default_doesnt_break_stuff
    p = Product.new
    p.price = "1,001.21"
    assert_equal 1001.21, p.price.to_f
  end
end