require_relative 'contact'
require 'byebug'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    show_menu if ARGV.empty?
    @command = ARGV[0]
    @arg = ARGV[1] unless ARGV[1] == nil
    check_command
  end

private

  # Print a list of available commands
  def show_menu
    menu = "\nHere is a list of available Commands
             new\t- Create a new contact
             list\t- List all contacts
             show\t- Show a contact
             search\t- Search contacts"
    puts menu
  end

  # Check the instant variable @command for possible inputs; routes to the proper method
  def check_command
    case @command
    when 'list' then show_contacts
    when 'new' then add_contact
    when 'find' then get_contact # TODO: Input check
    when 'search' then search_contacts
    else puts 'Command not recognized'
    end
  end

  # Prints all contacts to the console -- I'd prefer to call this all_contacts
  def show_contacts
    contacts = Contact.all
    display_contacts(contacts)
  end

  # Waits for user input and creates a new contact record
  def add_contact
    puts "Enter contact name:"
    name = STDIN.gets.chomp
    puts "Enter contact email:"
    email = STDIN.gets.chomp 
    Contact.create(name, email)
    # TODO: check to make sure input is valid; add helper methods
    puts "#{name} successfully added to contact list"
  end

  # Takes ID and display contact if it exists
  def get_contact
    contact = Contact.find(@arg)
    puts contact.nil? ? "Contact not found" : "#{contact[1]} (#{contact[2]})"
  end

  # Takes user input and searches contact list. Outputs all unique entries
  def search_contacts
    contacts = Contact.search(@arg.downcase).uniq
    display_contacts(contacts)
  end

  # Takes an array of contacts and formats the output
  def display_contacts(contacts)
    contacts.each { |contact| puts "#{contact[0]}: #{contact[1]} (#{contact[2]})" }
    puts "---"
    puts "#{contacts.size} records total"
  end
end

ContactList.new