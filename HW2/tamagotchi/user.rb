require 'yaml'
require 'pry'

class User

  GUEST_PERMISSIONS = ['play', 'eat', 'drink', 'treat', 'dream', 'awake', 'overwatch', 'grooming', 'restroom', 'walking', 'pet_status', 'help', 'pet_needs']
  ADMIN_PERMISSIONS = GUEST_PERMISSIONS + ['change_pet_type', 'change_pet_name']
  SUPERADMIN_PERMISSIONS = ADMIN_PERMISSIONS + ['change_score', 'kill_pet', 'set_default_score', 'change_pet_owner_name']

  attr_accessor :login, :password, :role 

  def initialize(login, password, role)
      @login = login 
      @password = password 
      @role = role
  end 

  def self.find(login, password)
    user_array = YAML.load(File.read("example.yml"))
    user_data = user_array.select { |i| i[:login] == login && i[:password] == password}.first
    if user_data
      user_role = user_data[:role]
      user = User.new(login, password, user_role)
      puts "Welcome, #{user.role}"
    else  
      print "Create new user yes/no => "
      answer = gets.chomp
      case answer
      when 'yes'
        new_user = { role: "GUEST", login: login, password: password }
        user_array.push(new_user)
        File.open('example.yml', 'w') { |f| f.write(YAML.dump(user_array)) }
      when 'no'  
        exit
      end
    end
  end  
end