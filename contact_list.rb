require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def initialize
    show_menu if ARGV.empty?
    @command = ARGV[0]
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
    else puts 'Command not recognized'
    end
  end

  # Prints all contacts to the console
  def show_contacts
    count = 0
    Contact.all.each do |rec| 
      count += 1
      puts "#{count}: #{rec[0]} (#{rec[1]})"
    end
    puts "---"
    puts "#{count} records total"
  end
end

ContactList.new