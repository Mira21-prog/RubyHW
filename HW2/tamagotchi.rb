require_relative 'cat2'
require_relative 'color'

class Pet
  include ConsoleImage

  def initialize(name:, params:, time:, dreams:, lifes:, toilet:)
    @name = name
    @dreams = dreams
    @time = time
    @params = params
    @lifes = lifes
    @toilet = toilet
    Thread.new { period_of_time }
  end

  def print_image(image_type)
    case image_type
    when 'cat'
      cat
    when 'dog'
      dog
    end
  end

  def play
    if @params[:mood] >= 100
      puts "I don't want to play. Let's play some other time".red
    else
      puts 'I like to play! Played well!'.light_blue
      @params[:energy] -= 20
      @params[:health] += 5
      @params[:hungry] -= 3
      @params[:thirst] += 10
    end
    check_life
  end

  def eat
    if @params[:hungry] <= 85
      puts "I don't want to eat.".red
      @params[:mood] -= 10
      @params[:energy] -= 5
    else
      puts 'Yummy. Thank you for feeding'.light_blue
      @params[:hungry] -= 10
      @params[:health] += 5
      @params[:energy] -= 10
      @params[:thirst] += 10
      @toilet = true
    end
    check_life
  end

  def drink
    if @params[:thirst] >= 100
      puts 'I don`t want to drink.'.red
      @params[:mood] -= 10
    else
      puts "Thank you. Now I don't want to drink anymore".light_blue
      @params[:health] += 5
      @params[:mood] += 5
      @params[:thirst] += 10
    end
    check_life
  end

  def treat
    if @params[:health] >= 100
      puts "I am well. Thanks'".red
      @params[:mood] -= 10
    else
      puts "Thank you. I'm healthy now".light_blue
      @params[:health] += 50
      @params[:mood] += 10
      @params[:thirst] += 5
      @params[:hungry] += 10
      @params[:energy] += 10
    end
    check_life
  end

  def dream
    puts 'zzZ zzZ zzZ zzZ zzZ  '.light_blue
    @dreams = true
    @params.each_with_object(@params) do |(key, _), hash|
      hash[key] += 5
    end
    check_life
  end

  def awake
    @time = Time.now
    puts 'Good morning! '.light_blue
    @dreams = false
    @params[:hungry] -= 3
    @params[:energy] -= 5
    @params[:mood] -= 5
    check_life
  end

  def mood
    if @params[:mood] >= 100
      puts 'I have a good mood'.red
    else
      @params[:mood] += 10
      @params[:health] += 10
      @params[:energy] += 10
      @params[:hungry] -= 3
    end
    check_life
  end

  def overwatch
    arr = %i[play eat drink treat dream awake mood grooming clean walking hug_pet].sample
    send(arr)
  end

  def grooming
    if @params[:dirty] >= 90
      puts "Thanks. I'm beautiful now.".red
    else
      puts "I'm very very  beautiful.".light_blue
      @params[:mood] += 8
      @params[:health] += 3
      @params[:energy] += 2
      @params[:hungry] -= 3
    end
    check_life
  end

  def restroom
    puts "I've done it.".light_blue
    @toilet = false
    check_life
  end

  def walking
    puts 'Thank you for walking with me'.light_blue
    @params[:mood] += 10
    @params[:energy] -= 10
    check_life
  end

  def hug_pet
    p 'Thanks. I am very happy'.light_blue
    @params[:mood] += 10
    @params[:health] += 3
    check_life
  end

  def help
    puts '•••••••••••••••••••••••••••••••••••••••••••••••••HELP••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red
    p "if you use a 'play' action, then you will improve his health and thirst"
    p "if you use a 'eat' action, then you will improve his health and thirst, energy"
    p "if you use a 'drink' action, then you will improve his health and thirst, mood"
    p "if you use a 'treat' action, then you will improve his health and thirst, energy, mood"
    p "if you use a 'dream' action, then you will improve all parameters"
    p "if you use a 'awake' action, then you will improve mood"
    p "if you use a 'overwatch' action, then a random action will be performed"
    p "if you use a 'grooming' action, then you will improve health and energy, mood"
    p "if you use a 'restroom' action, then he goes to the toilet"
    p "if you use a 'walking' action, then he walks somewhere"
    p "if you use a 'hug_pet' action, then he is happy"
    p "if you use a 'pet_status' action, then it will display the current characteristics of the pet from 0 to 100"
    p "also every 10 minutes the pet's characteristics will decrease during the game"
    puts '••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red
  end

  def pet_status
    parameters
    puts '••••••••••••••••••••••••••••••••••••••••••••••••••••••STATUS••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red
    @params.each do |key, value|
      puts "#{key}:".ljust(9, ' ') + '+'.green * value.to_s.to_i + '-'.yellow * (100 - value).to_s.to_i + value.to_s
    end
    puts '••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red
  end

  def pet_needs
    nparam = @params.select { |_, value| (1..30).include?(value) }
    if nparam == {}
      pet_status
    else
      nparam.each do |key, value|
        puts "Warning: I am #{key} with score #{value}. Please, improve it".red
      end
    end
    @toilet ? 'I need a toilet'.red : "I don't need a toilet".light_blue
    @dreams ? 'I am still asleep. Wake me up'.red : "I don't need to sleep".light_blue
  end

  private

  def current_state
    check_life
    pet_needs
  end

  def period_of_time
    loop do
      sleep(600)
      @params[:mood] -= 20
      @params[:health] -= 20
      @params[:energy] -= 20
    end
  end

  def parameters
    @params.each_with_object(@params) do |(key, _), hash|
      hash[key] = 100 if hash[key] > 100
      hash[key] = 0 if hash[key].negative?
    end
  end

  def check_life
    parameters
    values = @params.select { |_, value| value.zero? }
    if values.size.positive?
      @lifes -= 1
      if @lifes == 0

        puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.red
        p 'Your pet has lost 5 lives. Your pet is dead.               '
        puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.red
        exit
      else
        puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.red
        p "Your pet has lost one life. Now your pet has #{@lifes} lifes"
        p 'Please check status of pet with 0 value and correct this value'
        puts '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'.red
      end
    end
  end
end

print 'Please, write the name of the pet=>'.green

name = gets.chomp

params_hash = { hungry: 80, health: 80, energy: 80, thirst: 80, mood: 80, dirty: 80 }
pet = Pet.new(name: name, params: params_hash, time: Time.now, dreams: false, lifes: 5, toilet: false)

selected = false
until selected
  print 'Do you have a cat or a dog?=>'.green
  pet_type = gets.chomp
  if %w[cat dog].include?(pet_type)
    pet.print_image(pet_type)
    selected = true
  end
end

puts "WELCOME, #{name}"

puts '•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••MENU••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red
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
puts '••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••'.red

loop do
  print 'Enter command =>'.green
  option = gets.chomp
  case option
  when 'play'
    pet.play
  when 'eat'
    pet.eat
  when 'drink'
    pet.drink
  when 'treat'
    pet.treat
  when 'dream'
    pet.dream
  when 'awake'
    pet.awake
  when 'mood'
    pet.mood
  when 'overwatch'
    pet.overwatch
  when 'help'
    pet.help
  when 'grooming'
    pet.grooming
  when 'pet_status'
    pet.pet_status
  when 'restroom'
    pet.restroom
  when 'walking'
    pet.walking
  when 'pet_needs'
    pet.pet_needs
  when 'exit'
    exit
  else
    puts option + ' unknown command. To get list of commands type help'
  end
end
