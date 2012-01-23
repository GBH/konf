require 'test/unit'
require 'konf'

class KonfTest < Test::Unit::TestCase
  
  def test_initialization_as_hash
    conf = Konf.new('a' => {'b' => 'c'})
    assert_equal ({'a' => {'b' => 'c'}}), conf
  end
  
  def test_initialization_as_yaml
    conf = Konf.new(File.expand_path('config.yml', File.dirname(__FILE__)))
    assert_equal ({
      'conf_a' => {
        'conf_1' => 'value',
        'conf_2' => 'value 2',
      },
      'conf_b' => {
        'conf_1' => 'value'
      }
    }), conf
  end
  
  def test_initialization_as_invalid
    [nil, 99, 'invalid.yml', File.expand_path('blank_config.yml', File.dirname(__FILE__))].each do |source|
      begin
        Konf.new(source)
      rescue => e
        assert_equal Konf::Invalid, e.class, e.inspect
      end
    end
  end
  
  def test_initialization_with_root
    conf = Konf.new({'a' => {'b' => 'c'}}, 'a')
    assert_equal ({'b' => 'c'}), conf
  end
  
  def test_initialization_with_blank_source
    begin
      conf = Konf.new
    rescue => e
      assert_equal ArgumentError, e.class
    end
  end
  
  def test_initialization_with_invalid_root
    begin
      conf = Konf.new({'a' => {'b' => 'c'}}, 'd')
    rescue => e
      assert_equal Konf::NotFound, e.class
    end
  end
  
  def test_accessors
    conf = Konf.new('a' => {'b' => 'c'})
    
    assert_equal ({'b' => 'c'}), conf.a
    assert_equal Konf, conf.a.class
    assert_equal 'c', conf.a.b
  end
  
  def test_accessors_undefined
    conf = Konf.new('a' => {'b' => 'c'})
    begin
      conf.z
    rescue => e
      assert_equal Konf::NotFound, e.class
    end
  end
  
  def test_accessors_inspector
    conf = Konf.new('a' => {'b' => 'c'})
    assert conf.a?
    assert !conf.z?
    assert conf.a.b?
    assert !conf.a.z?
  end
  
end