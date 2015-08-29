require 'test/unit'
require_relative '../library'

  class Test_library_check_in_method < Test::Unit::TestCase

    def setup
      @lib = Library.instance
      @lib.open
      @lib.issue_card("rodrigo")
      @lib.serve("rodrigo")
    end

    #test check in method returns books to the library list and delete the same books from the member list
    def test_check_in_method

      #length of the library books list and member books list before check out method
      assert_equal(4, @lib.books_list.length)
      assert_equal(0, @lib.members_dictionary[@lib.current_served_member].books_out.length)

      #ids of the books to be checked out
      bks_out= [1,2,3]
      #checks out the books and adds to the member list
      @lib.check_out(bks_out.at(0),bks_out.at(1), bks_out.at(2))

      #books were removed from library books list and added to member books list
      assert_equal(1, @lib.books_list.length)
      assert_equal(3, @lib.members_dictionary[@lib.current_served_member].books_out.length)

      bks_to_return = [1,2,3]
      #checks the books in returning the books to the library list and deleting from members list
      @lib.check_in(bks_to_return.at(0).to_i,bks_to_return.at(1).to_i, bks_to_return.at(2).to_i)

      #books were returned to library list and removed from member list
      assert_equal(4, @lib.books_list.length)
      assert_equal(0, @lib.members_dictionary[@lib.current_served_member].books_out.length)

    end
  end