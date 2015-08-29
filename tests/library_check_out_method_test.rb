require 'test/unit'
require_relative '../library'

class Test_library_check_out_method < Test::Unit::TestCase
  def setup
    @lib = Library.instance
    @lib.open
    @lib.issue_card("rodrigo")
    @lib.serve("rodrigo")
    books_to_be_checked = [1, 2, 3]
    @lib.check_out(books_to_be_checked.at(0).to_i, books_to_be_checked.at(1).to_i, books_to_be_checked.at(2).to_i)
  end

  #test books are checked and added to member's list
  def test_check_out_method
    #checks if the id of the first book in the member list is the same as expected
    assert_equal(1, @lib.members_dictionary[@lib.current_served_member].books_out.at(0).get_id)
    #member's list length is the same as the number of books checked out
    assert_equal(3, @lib.members_dictionary[@lib.current_served_member].books_out.length)
    #books are deleted from library's list
    assert_equal(1, @lib.books_list.length)
    #the only book remained
    assert_equal(4, @lib.books_list.at(0).get_id)
  end
end