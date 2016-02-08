require 'csv'

# Represents a person in an address book.
class Contact
  @db = './contact_db.csv'
  
  attr_reader :name, :email, :id

  def initialize(name, email)
    @name = name
    @email = email
    # TODO: Set the new ID based on the last record in the list; will account for record deletion
    @id = (CSV.read(@db).last[0].to_i + 1).to_s
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      contacts = CSV.foreach(@db).to_a
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email)
      new_contact = Contact.new(name, email)
      CSV.open(@db, 'a') { |list| list << [new_contact.id, new_contact.name, new_contact.email] }
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      CSV.foreach(@db) do |row|
        return row if row[0] == id
      end
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end

end
