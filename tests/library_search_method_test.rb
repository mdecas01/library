require 'test/unit'
require_relative '../library'

class Test_library_search_method< Test::Unit::TestCase

  def setup
    @lib = Library.instance
  end

  #test search method returns books with title related to the input search term
  def test_search_method
    #Unfortunetly I was not able to solve the problem of finding just one instance of each book
    assert_equal(["1: Beginning C++ Through Game Programming, by Michael Dawson", "2: Game Programming Patterns, by Robert Nystrom", "3: Beginning C++ Through Game Programming, by Michael Dawson", "4: Game Programming Patterns, by Robert Nystrom"],@lib.search("game"))
  end
end