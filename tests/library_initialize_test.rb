require_relative '../library'
require 'test/unit'


  class Test_library_initialize_method < Test::Unit::TestCase
    def setup
      @lib = Library.instance()
    end

    def teardown
      @lib = nil
    end

    #test initialize method
    def test_initialize
      @bklist = @lib.books_list
      assert_equal("Michael Dawson", @bklist.at(0).get_author())
      assert_equal("Game Programming Patterns", @bklist[1].get_title)
      assert_equal("closed", @lib.flag)
    end

  end