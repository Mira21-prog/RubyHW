# frozen_string_literal: true

require 'pry'
require_relative 'color'
require_relative 'user'
require_relative 'pet'

class AthorizationError < StandardError
end

class Game
  attr_accessor :user

  def authorize!(method_name)
    unless User.const_get("#{user.role.upcase}_PERMISSIONS").include?(method_name)
      raise ::AthorizationError, "You are not allowed to call #{method_name}"
    end
  end
end

game = Game.new
print 'Enter login:'.green
login = gets.chomp
print 'Enter password:'.green
password = gets.chomp
user = User.find(login, password)
game.user = user

print "Please, write the pet's name =>".green

name = gets.chomp

params_hash = { hungry: 10, health: 80, energy: 80, thirst: 10, mood: 80, dirty: 80 }
pet = Pet.new(name: name, params: params_hash, time: Time.now, dreams: false, lifes: 5, toilet: false)

print 'What is your name? =>'.green

name_owner = gets.chomp

puts pet.pet_owner(name_owner)

pet.game = game

selected = false
until selected
  print 'Do you have a cat or a dog?=>'.green
  pet_type = gets.chomp
  if %w[cat dog].include?(pet_type)
    pet.image = pet.print_image(pet_type)
    selected = true
  end
end

def menu_for_user
  User::GUEST_PERMISSIONS.each { |a| p a }
end

def menu_for_admin
  User::ADMIN_PERMISSIONS.each { |a| p a }
end

def menu_for_superadmin
  User::SUPERADMIN_PERMISSIONS.each { |a| p a }
end

def get_user_role(user)
  case user.role
  when 'GUEST'
    menu_for_user
  when 'ADMIN'
    menu_for_admin
  else
    menu_for_superadmin
  end
end
get_user_role(game.user)

loop do
  begin
    print 'Enter command =>'.green
    option = gets.chomp
    pet.send(option)
    next unless pet.public_methods(false).include?(option.to_sym)

    get_all = pet.all_params
    File.open('pet.yml', 'w') { |f| f.write(YAML.dump(get_all)) }
    pet_params = pet.pet_status
    content = PetAdapter.new(pet_params, pet.pet_message, pet.name, pet.image).to_s
    get_content(content, 'index', true)
    @a ||= Launchy.open('./tmp/index.html')
  rescue AthorizationError => e
    puts e.message
    next
  end
end
