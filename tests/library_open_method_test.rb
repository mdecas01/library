require 'test/unit'
require_relative '../library'

  class Test_library_open_method < Test::Unit::TestCase
    def setup
      @lib2 = Library.instance()
      #sets the flag to open so that the open method will raise exception
      @lib2.flag = "open"
    end

    #test_open method raises runtime error since flag was already open during initialization
    def test_open_method
      assert_raise(RuntimeError ){@lib2.open()}
    end

  end