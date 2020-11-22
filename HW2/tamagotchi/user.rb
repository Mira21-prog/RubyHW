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
        if login == 'alan' && password=='alan' 
          role = 'GUEST'
          user = User.new(login, password, role)
          a = user.to_hash
          user.save(a)
          user
        elsif login == 'bob' && password=='bob'
          role = 'ADMIN' 
          admin = User.new(login, password, role)
          a = admin.to_hash
          admin.save(a)
          admin
        elsif login == 'dean' && password=='dean'
          @role = 'SUPERADMIN' 
          superadmin = User.new(login, password, role)
          a = superadmin.to_hash
          superadmin.save(a)
          superadmin
        else   
          "Cteate a new user yes/no?"
          ans = gets.chomp 
          if ans == 'yes'
            new_user = User.new(login, password, role)
            a = new_user.to_hash
            new_user.save(a)
            new_user
          else 
            ans == 'no'
            return
          end
        end 
    end 
 
    def save(a)
      File.open("user.yml", "w") { |file| file.write(a.to_yaml)}
    end 

    def to_hash
      hash = {}
      instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
      hash
    end
end 


