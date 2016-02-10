require 'csv'

# Represents a person in an address book.
class Contact
  @@db = './contact_db.csv'

  attr_reader :name, :email, :id, :phone

  def initialize(name, email, id, phone)
    @name = name
    @email = email
    @id = id
    @phone = phone
  end

  class << self
    # Returns an Array of Contacts loaded from the database.
    def all
      contacts = CSV.foreach(@@db).to_a
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email, phone)
      new_contact = Contact.new(name, email, next_id, phone)
      CSV.open(@@db, 'a') { |list| list << [new_contact.id, new_contact.name, new_contact.email, new_contact.phone] }
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      CSV.foreach(@@db) do |row|
        return row if row[0] == id
      end
    end

    # Returns an array of contacts who match the given term.
    def search(term)
      found = []
      CSV.foreach(@@db) do |row|
        row.each {|el| found.push(row) if el.downcase.include?(term)}
      end
      found
    end

    # Take a string email and checks to see of it already exists in the contact_list. Returns boolean
    def uniq_email?(email)
      # TODO: Add a break once a since entry is found; rewrite method without using search
      true if search(email).empty?
    end

    # Checks the db and return the next id in the sequence
    def next_id
      CSV.read(@@db).last[0].to_i + 1
    end
  end
end
