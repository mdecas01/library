require_relative 'library'
require 'test/unit'

  class TestMember < Test::Unit::TestCase

    def setup
      @lib = Library.instance()
      @member = Member.new("Rodrigo", @lib)
    end

    #test get name method
    def test_get_name
      assert_equal("Rodrigo", @member.get_name)
    end

    #test check out method
    def test_check_out
       first_book = Book.new(1,"this is a title", "this is an author")
       second_book = Book.new(2, "another title", "another author")

       @member.check_out(first_book)
       @member.check_out(second_book)
       #check book was added to the member's list
       assert_equal("this is an author", @member.books_out[0].get_author())
       #checks if the due date in the book object was correctly set
       assert_equal(7, @member.books_out[0].get_due_date)
       assert_equal(7, @member.books_out[1].get_due_date)
    end

    #test give back method
    def test_give_back
      first_book = Book.new(1,"this is a title", "this is an author")
      second_book = Book.new(2, "another title", "another author")

      @member.check_out(first_book)
      @member.check_out(second_book)

      #the member list BEFORE the give back method is called
      assert_equal(2, @member.books_out.length)

      #calls the give back method
      @member.give_back(@member.books_out[0])

      #member's list after the give back method is called
      assert_equal(1, @member.books_out.length)
    end

   #test send notice method
   def test_send_overdue_notice
      @expected_notice = "Dear Rodrigo, you have overdue books."
      assert_equal(@expected_notice, @member.send_overdue_notice("you have overdue books."))
   end
  end