#!/usr/bin/env ruby 

require_relative 'contact'
require 'byebug'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    return show_menu if ARGV.empty?
    @command = ARGV[0]
    @arg = ARGV[1] unless ARGV[1] == nil
    check_command
  end

private

  # Print a list of available commands
  def show_menu
    menu = "\n Available Commands:
             new\t- Create a new contact
             list\t- List all contacts
             show\t- Show a contact
             search\t- Search contacts\n\n"
    puts menu
  end

  # Check the instant variable @command for possible inputs; routes to the proper method
  def check_command
    case @command
    when 'list' then show_contacts
    when 'new' then add_contact
    when 'find' then get_contact # TODO: Input check
    when 'search' then search_contacts
    else 
      puts "\n Command not recognized"
      show_menu
    end
  end

  # Prints all contacts to the console -- I'd prefer to call this all_contacts
  def show_contacts
    contacts = Contact.all
    contacts.size <= 5 ? display_contacts(contacts) : paginate(contacts, 5)
  end

  # Waits for user input and creates a new contact record
  # TODO: Add better validation
  def add_contact
    puts " Enter contact name:"
    name = STDIN.gets.chomp
    puts " Enter contact email:"
    email = STDIN.gets.chomp
    if Contact.uniq_email?(email)
      Contact.create(name, email)
      puts " #{name} successfully added to contact list"
    else
      puts " #{email} already exists! Contact not added"
    end
  end

  # Takes ID and display contact if it exists
  def get_contact
    contact = Contact.find(@arg)
    puts contact.nil? ? " Contact not found" : " #{contact[1]} (#{contact[2]})"
  end

  # Takes user input and searches contact list. Outputs all unique entries
  def search_contacts
    contacts = Contact.search(@arg.downcase).uniq
    display_contacts(contacts, false)
  end

  # Takes an array of contacts and formats the output
  def display_contacts(contacts, paginated)
    contacts.each { |contact| puts " #{contact[0]}: #{contact[1]} (#{contact[2]})" }
    puts "---\n #{contacts.size} records total\n\n" unless paginated
  end

  # Take an array of contacts and paginates through them; returns nil
  def paginate(contacts, num_per_page)
    system "clear"
    pages = contacts.each_slice(num_per_page)
    pages.each_with_index do |page, i| 
      puts " Page #{i + 1} of #{pages.count}"
      display_contacts(page, true)
      wait_for_enter
    end
  end

  def wait_for_enter
    puts "\n hit enter to continue"
    STDIN.gets.chomp
  end
end

ContactList.new