require 'test/unit'
require_relative '../library'

class Test_library_renew_method < Test::Unit::TestCase

  def setup
    @lib = Library.instance
    @lib.open
    @lib.issue_card("rodrigo")
    @lib.serve("rodrigo")
    bks_out = [1,2,3]
    @lib.check_out(bks_out.at(0),bks_out.at(1), bks_out.at(2))
  end

  # test renew method changes book's due date and returns the correct number of books renewed
  def test_renew_method

    #DUE DATE of the first book in the member list BEFORE renew method
    assert_equal(8, @lib.members_dictionary[@lib.current_served_member].books_out.at(0).get_due_date)

    #list of ids of books that will be renewed
    bks_out2 = [1,2,5]
    @renew_method_invocation = @lib.renew(bks_out2.at(0).to_i, bks_out2.at(1).to_i, bks_out2.at(2).to_i)

    #DUE DATE of book in the member list AFTER renew method
    assert_equal(15, @lib.members_dictionary[@lib.current_served_member].books_out.at(0).get_due_date)

    #the correct number of books renewed
    assert_equal("2 books have been renewed for Rodrigo", @renew_method_invocation)
  end
end