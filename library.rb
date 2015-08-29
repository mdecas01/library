require 'singleton'
require 'green_shoes'

  #
  #Author:; Rodrigo Magalhaes de Castro / mdecas01
  #
  class Calendar
    #Only one instance of the class is created
    include Singleton

    def initialize
      @date = 0 unless @date
    end

    def get_date
      @date
    end

    #Advances the date by one day
    def advance
      @date += 1
    end
  end

  class Book
    #The date in which the member has to return the book to the library
    attr_accessor :due_date
    @id = nil
    @title = nil
    @author = nil

    #creates a book object with the information provided in the parameters
    def initialize(id, title, author)
      @id = id
      @title = title
      @author = author
      @due_date = 0 unless @due_date
    end

    def get_id
      @id
    end

    def get_title
      @title
    end

    def get_author
      @author
    end

    def get_due_date
      @due_date
    end

    #Sets the due date of the book to the current date plus the due_date in the parameter
    def check_out(due_date)
      @due_date = Calendar.instance.get_date + due_date
    end

    #Resets the due date of the book to nil
    def check_in
      @due_date = nil
    end

    #Retunrs a string containing the book's information
    def to_s
      "#{@id}: #{@title}, by #{@author}"
    end
  end

  class Member
    #List of the books that were checked out by the member
    attr_accessor  :books_out
    @name
    #The library instance related to the member
    @library

    def initialize(name, library)
      @name = name.downcase
      @library = library
      @books_out = [] unless @books_out
    end

    def get_name
      @name.capitalize
    end

    #Calls the book's check out method and sets the book's due date to the actual date plus 7 days
    #and adds the book to the list of books checked out by the member
    def check_out(book)
      book.check_out(7)
      @books_out.push(book)
    end

    #deletes the book from the member list
    def give_back(book)
      @books_out.delete(book)
    end

    def get_books
      @books_out
    end

    def send_overdue_notice(notice)
      "Dear #{@name.capitalize}, " + notice
    end
  end

  class Library
    include Singleton
    attr_accessor :flag, :members_dictionary, :current_served_member, :books_list, :cal

    def initialize
      lines = []
      @members_dictionary = Hash.new
      #calendar instance
      @cal = Calendar.instance
      #indicates that the library is closed
      @flag = 'closed'

      begin
        #gets the details from the file "collection.txt" which is the file containing the book's informations
        file = File.open('collection.txt')
        if file
          #this will be the initial id given to the books in the library's list
          i = 1
          while line = file.gets
            @books_list = [] unless @books_list
            lines = line.split(',')
            @books_list.push(Book.new(i, lines[0], lines[1].strip))
            i += 1
          end
        end
      rescue
        file = STDIN
        puts 'ERROR: An problem with an nonexistent file occured ON library.rb LINE 96.'
      ensure
        file.close
      end
    end

    def open
      raise 'ERROR: The library is already open' if @flag == 'open'
      @cal.advance
      @flag = 'open'
      puts "Today is day #{Calendar.instance.get_date}."
    end

    def find_all_overdue_books
      members_and_overdue_books = []
      #searches the dictionary with members, gets the list of books checked out by each member object, and checks if they have overdue books
      @members_dictionary.each{ |k,v| v.books_out.each { |x| if x.get_due_date < self.cal.get_date
                                                               members_and_overdue_books.push(k + " has the book \""  + x.get_title + "\" overdue.")
                                                             end
                                                        }
      }
      members_and_overdue_books
    end

    def issue_card(name_of_member)
      #sets the names for downcase only
      formatted_name = name_of_member.downcase
      member = Member.new(formatted_name, Library.instance)
      if @members_dictionary.has_key?(formatted_name)
         "#{name_of_member} already has a library card."
      else
        @members_dictionary[formatted_name] = member
      end
    end

    def serve(name_of_member)
      form_name = name_of_member.downcase
      #if another member is being served quits serving him/her
      if @current_served_member != nil
        @current_served_member = nil
        self.serve(form_name)
      else
        if @members_dictionary.has_key?(form_name)
          @current_served_member = form_name
          "Now serving #{form_name.capitalize}"
        else
          "#{form_name.capitalize} does not have a library card."
        end
      end
    end

    def find_overdue_books
      overdue_books = []
      raise 'The library is closed' if @flag == 'closed'
      raise 'No member is currently being served.' if @current_served_member == nil
      member = @members_dictionary[@current_served_member]
      #adds the books that are overdue to the array of overdue books
      member.books_out.map{ |x| if x.get_due_date < self.cal.get_date
                                  overdue_books.push(x.to_s)
                                end}
      if overdue_books.length > 0
        overdue_books
      else
        'NONE'
      end
    end

    def search(string)
      begin
        raise  if string.length < 4
        #creates the list with author and title to be returned
        books_found = []
        self.books_list.each {|x| if /#{string}/i.match(x.get_author) || /#{string}/i.match(x.get_title)
                                  #creates a hash with author and title
                                  books_found.push(x.to_s)
                                end }
        if books_found.empty?
           "No book related to the term \"#{string}\" was found"
        else
          books_found
        end
      rescue
         'ERROR: search query must be at least 4 charachteres long'
      end
    end

    def check_out(*books_ids)
      raise 'The library is not open' if self.flag == 'closed'
      raise 'No member is currently being served' if self.current_served_member == nil
      #ids of the books that will be removed from books_list after member checkout
      books_to_delete =[]
      for i in 0..books_ids.length-1
        for j in 0..@books_list.length-1
          #if the id in the book list is the same as in the ids list
          if books_ids.at(i) == @books_list.at(j).get_id
            @members_dictionary[@current_served_member].check_out(@books_list.at(j))
            books_to_delete.push(books_ids.at(i))
            break
          end
        end
      end
      #displays list of books that have been checked by the member
      puts "#{books_to_delete.length} books have been checked out by #{@current_served_member.capitalize}"
      puts "LIST OF BOOKS CHECKED OUT TO #{@current_served_member.capitalize}"
      @members_dictionary[@current_served_member].books_out.each{|x| puts x.to_s}
      #displays books not in the library's list
      ids_not_in = books_ids - books_to_delete
      if ids_not_in.length > 0
        ids_not_in.each{ |x| if x != 0
                                 puts "The library does not have book #{x}" end}
      end
      #deletes books from book's list
      @books_list.delete_if{|x| books_to_delete.include?(x.get_id)}
    end

    def check_in(*books_numbers)
      begin
        raise 'No member is being served.' if @current_served_member == nil
      rescue
        puts 'Enter name of member to be served.'
        self.serve(gets.chomp)
      end
      #add books to the library list and delete from member list
      bk_del_mem_list = []
      for i in 0..@members_dictionary[@current_served_member].books_out.length-1
        for j in 0..books_numbers.length-1
          if @members_dictionary[@current_served_member].books_out.at(i).get_id == books_numbers.at(j)
            @books_list.push(@members_dictionary[@current_served_member].books_out.at(i))
            bk_del_mem_list.push(books_numbers.at(j))
          end
        end
      end
      @members_dictionary[@current_served_member].books_out.delete_if{|b| bk_del_mem_list.include?(b.get_id) }  ##should use give back instead //check_in test
      @books_list.map{|x| x.due_date = nil}
    end

    def renew(*books_ids)
      raise 'The library is not open' if  self.flag == 'closed'
      raise 'No member is currently being served.' if self.current_served_member == nil
      ids_of_bks_renew = []
      for i in 0..@members_dictionary[@current_served_member].books_out.length-1
        #if the id of the members book is in the list to be renewed
        if books_ids.include?(@members_dictionary[@current_served_member].books_out.at(i).get_id)
          #increases the due date of the book in 7 days
          @members_dictionary[@current_served_member].books_out.at(i).due_date += 7
            #adds the ids os books that were renewed to array
            ids_of_bks_renew.push(@members_dictionary[@current_served_member].books_out.at(i).get_id)
          end
        end
      #finds which books ids are not in the member's list
      not_in_mem_list = books_ids - ids_of_bks_renew
      not_in_mem_list.each{|id| puts "The member does not have book #{id}"}
      "#{ids_of_bks_renew.length} books have been renewed for #{@current_served_member.capitalize}"
    end

    def close
        raise  'The library is not open.' if self.flag == 'closed'
        self.flag = 'closed'
        'Good night.'
    end

    #closes the library by eliminating instance variables and methods
    def quit
      undef :initialize, :open, :find_all_overdue_books, :issue_card, :serve, :find_overdue_books, :search, :check_out, :check_in, :renew, :close, :quit
      self.flag = nil
      self.members_dictionary = nil
      self.current_served_member = nil
      self.books_list = nil
      self.cal = nil
      'The library is now closed for renovations.'
    end
  end



