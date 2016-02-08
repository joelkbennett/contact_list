require 'csv'

# Represents a person in an address book.
class Contact
  @db = './contact_db.csv'
  # TODO: Use this better; that is, instead of next_id, just keep a read copy of the db available
  @next_id = CSV.read(@db).last[0].to_i + 1

  attr_reader :name, :email, :id

  def initialize(name, email, id)
    # TODO: Tighten this ID business up
    @name = name
    @email = email
    @id = id
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      contacts = CSV.foreach(@db).to_a
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email)
      new_contact = Contact.new(name, email, @next_id)
      CSV.open(@db, 'a') { |list| list << [new_contact.id, new_contact.name, new_contact.email] }
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      CSV.foreach(@db) do |row|
        return row if row[0] == id
      end
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      found = []
      CSV.foreach(@db) do |row|
        row.each {|el| found.push(row) if el.downcase.include?(term)}
      end
      found
    end

    # Take a string email and checks to see of it already exists in the contact_list. Returns boolean
    def uniq_email?(email)
      true if search(email).empty?
    end
  end

end
