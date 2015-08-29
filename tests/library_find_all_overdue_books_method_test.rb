require_relative '../library'
require 'test/unit'

  class Test_library_find_all_overdue__books_method < Test::Unit::TestCase

    def setup
       @lib = Library.instance
       @lib.open
       #creates members and add to dictionary
       @lib.issue_card("Rodrigo")
       @lib.issue_card("Kate")
       @lib.issue_card("anne")

       #object members are assigned to variables
       @memObj1 = @lib.members_dictionary["rodrigo"]
       @memObj2 = @lib.members_dictionary["kate"]
       @memObj3 = @lib.members_dictionary["anne"]

       #adds the book to the member list
       @memObj1.check_out(@lib.books_list[0])
       @memObj2.check_out(@lib.books_list[1])

       #advances the library's day to the day 9
       for i in 0..9 do @lib.cal.advance() end
    end

    #test method finds overdue books from member's list of books checked out
    def test_find_all_overdue_book
      #only those members with overdue books and the respective books are returned
      assert_equal(["rodrigo has the book \"Beginning C++ Through Game Programming\" overdue.","kate has the book \"Game Programming Patterns\" overdue."], @lib.find_all_overdue_books())
  end

end