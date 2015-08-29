require 'test/unit'
require_relative '../library'

class Test_library_open_method2 < Test::Unit::TestCase

  def setup
    @lib = Library.instance
    @lib.open
  end

  #test open method sets date to one and changes flag from closed to open
  def test_open_method2
    assert_equal(1, @lib.cal.get_date())
    assert_equal("open", @lib.flag)
  end

end