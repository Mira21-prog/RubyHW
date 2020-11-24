require 'pry'
require_relative 'color'
require_relative 'user'
require_relative 'pet'

class Game 
  attr_accessor :user

  def authorize!(method_name)
    raise unless User.const_get("#{user.role.upcase}_PERMISSIONS").include?(method_name)
  end
end 

game = Game.new
puts "Enter login:"
login = gets.chomp
puts "Enter password:"
password = gets.chomp 
user = User.find(login, password)
game.user = user

print "Please, write the pet's name =>".green

name = gets.chomp
 
params_hash = { hungry: 10, health: 80, energy: 80, thirst: 10, mood: 80, dirty: 80 }
pet = Pet.new(name: name, params: params_hash, time: Time.now, dreams: false, lifes: 5, toilet: false)

print "What is your name? =>".green 

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

puts '--Menu:--'.green
p 'play'
p 'eat'
p 'drink'
p 'treat'
p 'dream'
p 'awake'
p 'overwatch'
p 'grooming'
p 'restroom'
p 'walking'
p 'pet_status'
p 'help'
p 'pet_needs'
puts '--------'.green

loop do
  print 'Enter command =>'.green
  option = gets.chomp
  pet.send(option)
  next unless pet.public_methods(false).include?(option.to_sym)

  pet_params = pet.pet_status
 
  content = PetAdapter.new(pet_params, pet.pet_message, pet.name, pet.image).to_s
  get_content(content, 'index', true)
  @a ||= Launchy.open('./tmp/index.html')

end
