require 'test/unit'
require_relative '../library'

class Test_quit_method < Test::Unit::TestCase

  def setup
    @lib = Library.instance
  end

  #test all the instance variables are set no nil and methods are undefined
  def test_quit_method
    #tests if the library is definitely closed
    assert_raise(NoMethodError ){@lib2.issue_card("rodrigo")}
  end
end