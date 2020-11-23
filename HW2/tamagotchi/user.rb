require 'yaml'
require 'pry'

class User

  GUEST_PERMISSIONS = ['play', 'eat', 'drink', 'treat', 'dream', 'awake', 'overwatch', 'grooming', 'restroom', 'walking', 'pet_status', 'help', 'pet_needs']
  ADMIN_PERMISSIONS = GUEST_PERMISSIONS + ['change_pet_type', 'change_pet_name']
  SUPERADMIN_PERMISSIONS = ADMIN_PERMISSIONS + ['change_score', 'kill_pet', 'set_default_score', 'change_pet_owner_name']

  attr_accessor :login, :password, :role 

  def initialize(login, password, role = nil)
      @login = login 
      @password = password 
      @role = role
  end 

  def self.find(login, password)
    pet_array = YAML.load(File.read("example.yml"))
    new_array = if pet_array.select {|i| i[:login] = login && i[:password] = password}
      user = User.new(login, password)
      File.open("#{new_array[:role]}.yml", "w") { |file| file.write(new_array.to_yaml)}
    else  
      print "Create new user yes/no => "
      answer = gets.chomp
      case answer 
      when 'yes'
        user = User.new(login, password)
        new_user_array = [{:role=>"GUEST", :login=>login, :password=>password}]
        pet_array << new_user_array
        File.open("example.yml", "w") { |file| file.write(new_array.to_yaml)}
      else  
        "You enter invalid login or password. Please, try again!"
      end
    end 
  end
  user
end