require 'test/unit'
require_relative '../library'

class Test_library_close_method < Test::Unit::TestCase

  def setup
    @lib = Library.instance
    @lib.open
  end

  #test close method changes the flag to close and returns message
  def test_close_method
    #flag variable indicates that library is open
    assert_equal("open", @lib.flag)

    #calls close method
    @close_method_invocation = @lib.close

    #flag variable now indicates that the library is closed
    assert_equal("closed", @lib.flag)

    #close method returns correct string
    assert_equal("Good night.", @close_method_invocation)
  end

end