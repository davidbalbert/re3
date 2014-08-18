require 'minitest/autorun'

require 're3'

class RegexpTest < Minitest::Test
  ENGINES = [:recursive, :thompson, :recursive_vm]

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

  def test_or
    r = Re3::Regexp.new "aa|ab"

    ENGINES.each do |e|
      assert r.match("aa", e)
      assert r.match("ab", e)
      refute r.match("bb", e)
      refute r.match("a", e)
    end
  end

  def test_maybe
    r = Re3::Regexp.new "a?"

    ENGINES.each do |e|
      assert r.match("", e)
      assert r.match("a", e)
      refute r.match("aa", e)
      refute r.match("b", e)
    end
  end

  def test_any
    r = Re3::Regexp.new "a*"

    ENGINES.each do |e|
      assert r.match("", e)
      assert r.match("a", e)
      assert r.match("aa", e)
      refute r.match("b", e)
    end
  end

  def test_at_least_one
    r = Re3::Regexp.new "a+"

    ENGINES.each do |e|
      refute r.match("", e)
      assert r.match("a", e)
      assert r.match("aa", e)
      refute r.match("b", e)
    end
  end

  def test_complex_repitition
    r = Re3::Regexp.new "a?b*c+"

    ENGINES.each do |e|
      refute r.match("", e)
      assert r.match("ccc", e)
      assert r.match("acc", e)
      refute r.match("aac", e)
      assert r.match("abc", e)
    end
  end

  def test_group
    r = Re3::Regexp.new("(ab)+(cd)?")

    ENGINES.each do |e|
      refute r.match("", e)
      assert r.match("ab", e)
      assert r.match("abab", e)
      assert r.match("abcd", e)
      assert r.match("ababcd", e)
    end
  end
end
