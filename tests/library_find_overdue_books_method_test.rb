require_relative '../library'
require 'test/unit'

  class Test_library_find_overdue_books_method < Test::Unit::TestCase

    def setup
      @lib = Library.instance
      @lib.open
      @lib.issue_card("Rodrigo")

      #member currently being served
      @lib.serve("Rodrigo")

      #calls check out method and adds books to the member's list
      @lib.members_dictionary[@lib.current_served_member].check_out(@lib.books_list[0])
      @lib.members_dictionary[@lib.current_served_member].check_out(@lib.books_list[1])

      #advances the library date
      for i in 0..10 do
        @lib.cal.advance
      end

      #this book checked out would have the due date higher than the current date therefore would not be returned in the find overdue books method
      @lib.members_dictionary[@lib.current_served_member].check_out(@lib.books_list[2])

    end

    #test "find_overdue_books" method
    def test_find_overdue_books

      #only the books that have due date less than current date are found
      assert_equal(["1: Beginning C++ Through Game Programming, by Michael Dawson", "2: Game Programming Patterns, by Robert Nystrom"], @lib.find_overdue_books)

    end
  end