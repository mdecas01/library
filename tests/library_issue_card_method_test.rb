require_relative '../library'
require 'test/unit'

  class Test_library_issue_card_method < Test::Unit::TestCase

    def setup
      @lib = Library.instance
    end

    #test "issue_card" method
    def test_issue_card
      @lib.issue_card("Rodrigo")

      #member with name above was added to the members_dictionary list
      assert_equal("Rodrigo", @lib.members_dictionary["rodrigo"].get_name)
    end

    #test if method recognizes that member was already issued a card
    def test_issue_card2
      assert_equal("Rodrigo already has a library card.", @lib.issue_card("Rodrigo"))
    end

  end