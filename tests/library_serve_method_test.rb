require_relative '../library'
require 'test/unit'

  class Test_library_serve_method < Test::Unit::TestCase

    def setup
      @lib = Library.instance
    end

    def teardown
      @lib = nil
    end

    #test serve method returns member does not have library card message
    def test_serve_method
      assert_equal("Rodrigo does not have a library card.", @lib.serve("Rodrigo"))
    end
  end

  class Test_library_serve_method2 < Test::Unit::TestCase

    def setup
      @lib = Library.instance
    end

    def teardown
      @lib = nil
    end

    #test serve method assigns member to the current served member variable
    def test_serve_method
      @lib.issue_card("Rodrigo")
      @lib.serve("Rodrigo")
      assert_equal("rodrigo", @lib.current_served_member )
    end

    #test server method serves another member
    def test_serve_method2
      @lib.issue_card("Kate")
      @lib.serve("Kate")
      assert_equal("kate", @lib.current_served_member )
    end
  end