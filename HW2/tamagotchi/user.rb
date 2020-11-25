# frozen_string_literal: true

require 'yaml'
require 'pry'

class User
  GUEST_PERMISSIONS = %w[play eat drink treat dream awake overwatch grooming restroom walking pet_status help pet_needs]
  ADMIN_PERMISSIONS = GUEST_PERMISSIONS + %w[change_pet_type change_pet_name]
  SUPERADMIN_PERMISSIONS = ADMIN_PERMISSIONS + %w[change_score kill_pet set_default_score change_pet_owner_name]

  attr_accessor :login, :password, :role

  def initialize(login, password, role)
    @login = login
    @password = password
    @role = role
  end

  class << self
    def find(login, password)
      user_array = YAML.load(File.read('example.yml'))
      user_data = user_array.select { |i| i[:login] == login && i[:password] == password }.first
      user_data ? create_user(user_data, login, password) : create_new_user(login, password, user_array)
    end

    private

    def create_user(user_data, login, password)
      user_role = user_data[:role]
      user = User.new(login, password, user_role)
      puts "Welcome, #{user.role}!"
      user
    end

    def create_new_user(login, password, user_array)
      print 'Create new user yes/no => '
      answer = gets.chomp
      case answer
      when 'yes'
        new_user = { role: 'GUEST', login: login, password: password }
        user_array.push(new_user)
        File.open('example.yml', 'w') { |f| f.write(YAML.dump(user_array)) }
      when 'no'
        exit
      end
    end
  end
end