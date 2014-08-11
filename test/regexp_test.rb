require 'minitest/autorun'

require 're3'

class RegexpTest < Minitest::Test
  ENGINES = [Re3::Engines::ThompsonEngine]

  def test_simple_match
    r = Re3::Regexp.new "hello"

    ENGINES.each do |e|
      assert r.match("hello", e)
    end
  end

  def test_too_short
    r = Re3::Regexp.new "hello"

    ENGINES.each do |e|
      refute r.match("hell", e)
    end
  end

  def test_too_long
    r = Re3::Regexp.new "hello"

    ENGINES.each do |e|
      refute r.match("hellothere", e)
    end
  end

  def test_different
    r = Re3::Regexp.new "hello"

    ENGINES.each do |e|
      refute r.match("he11o", e)
    end
  end
end
