require_relative 'library'
require 'test/unit'

  class TestBook < Test::Unit::TestCase
    def setup
      @book = Book.new(1, "aaa", "bbb")
    end

    def teardown
      @book = nil
    end

    def test_get_id
      assert_equal(1, @book.get_id())
    end

    def test_get_title
      assert_equal("aaa", @book.get_title())
    end

    def test_get_author
      assert_equal("bbb", @book.get_author())
    end

    def test_get_due_date
      assert_equal(0, @book.get_due_date())
    end

    def test_check_out
      assert_equal(7, @book.check_out(7))
    end

    def test_check_in
      @book.check_in()
      assert_equal(nil, @book.get_due_date())
    end

    def test_to_s
      assert_equal("1: aaa, by bbb", @book.to_s())
    end

  end