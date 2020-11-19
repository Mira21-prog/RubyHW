require_relative 'color'
require_relative 'pet_adapter'
require 'content_flip'
require 'launchy'
require 'pry'

class Pet
  attr_reader :pet_message

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
      'cat'
    when 'dog'
      'dog'
    end
  end

  def play
    if @params[:mood] >= 100
      @pet_message = "Info! I don't want to play. Let's play some other time ""\u{1F610}"
    else
      @params[:energy] -= 20
      @params[:health] += 5
      @params[:hungry] -= 3
      @params[:thirst] += 10
      @params[:dirty] += 8
      @pet_message = "Success! I like to play! Played well!" "\u{1F60C}"
    end
    check_life
  end

  def eat
    if @params[:hungry] <= 85
      @params[:energy] -= 5
      @pet_message = "Info! I don't want to eat." "\u{1F610}"
    else
      @params[:hungry] -= 10
      @params[:health] += 5
      @params[:energy] -= 10
      @params[:thirst] -= 5
      @params[:mood] += 5
      @toilet = true
      @pet_message = "Success! Yummy. Thank you for feeding" "\u{1F60C}"
    end
    check_life
  end

  def drink
    if @params[:thirst] >= 30
      @params[:mood] -= 10
      @pet_message = 'Info! I don`t want to drink.' "\u{1F610}"
    else
      @params[:health] += 5
      @params[:mood] -= 5
      @params[:thirst] -= 10
      @pet_message = "Success! Thank you. Now I don't want to drink anymore" "\u{1F618}"
    end
    check_life
  end

  def treat
    if @params[:health] >= 100
      @params[:mood] -= 10
      @pet_message = "Info! I am well. Thanks" "\u{1F60E}"
    else
      @params[:health] += 20
      @params[:mood] += 10
      @params[:thirst] += 5
      @params[:hungry] += 10
      @params[:energy] += 5
      @params[:dirty] += 5
      @pet_message = "Success! Thank you. I'm healthy now" "\u{1F618}" 
    end
    check_life
  end

  def dream
    @dreams = true
    @params.each_with_object(@params) do |(key, _), hash|
      hash[key] -= 3
    end
    @pet_message = 'zzZ zzZ zzZ zzZ zzZ' "\u{1F634}"
    check_life
  end

  def awake
    @time = Time.now
    @dreams = false
    @params[:hungry] += 3
    @params[:energy] -= 5
    @params[:mood] -= 5
    @params[:dirty] += 5
    @pet_message = 'Good morning!'"\u{1F60C}"
    check_life
  end

  def mood
    if @params[:mood] >= 100
      @pet_message = 'Info! I have a good mood' "\u{1F44C}"
    else
      @params[:mood] += 10
      @params[:health] += 10
      @params[:energy] += 10
      @params[:hungry] -= 3
      @pet_message = 'Success! You improved my mood' "\u{1F64F}"
    end
    check_life
  end

  def overwatch
    arr = %i[play eat drink treat dream awake mood grooming clean walking hug_pet].sample
    send(arr)
  end

  def grooming
    if @params[:dirty] >= 90
      @pet_message = "Info! Thanks. I'm beautiful now." "\u{2764}"
    else
      @params[:mood] += 8
      @params[:health] += 3
      @params[:energy] += 2
      @params[:hungry] -= 3
      @params[:dirty] -= 4
      @pet_message = "Success! I'm very beautiful." "\u{2764}"
    end
    check_life
  end

  def restroom
    @toilet = false
    @pet_message = "Info! I've done it." "\u{1F44C}"
    @params[:health] += 3
    @params[:thirst] += 3
    @params[:dirty] += 3
    check_life
  end

  def walking
    @params[:mood] += 10
    @params[:energy] -= 10
    @params[:dirty] += 10
    @pet_message = "Success! Thank you for walking with me" "\u{1F618}"
    check_life
  end

  def hug_pet
    @params[:mood] += 10
    @params[:health] += 3
    @pet_message = "Success! Thanks. I am very happy" "\u{1F607}""\u{1F917}"
    check_life
  end

  def help
    puts "Help:>
    <p>if you use a 'play' action, then you will improve his health and thirst</p>
    <p>if you use a 'eat' action, then you will improve his health and thirst, energy</p>
    <p>if you use a 'drink' action, then you will improve his health and thirst, mood</p>
    <p>if you use a 'treat' action, then you will improve his health and thirst, energy, mood</p>
    <p>if you use a 'dream' action, then you will improve all parameters<p>
    <p>if you use a 'awake' action, then you will improve mood</p>
    <p>if you use a 'overwatch' action, then a random action will be performed</p>
    <p>if you use a 'grooming' action, then you will improve health and energy, mood</p>
    <p>if you use a 'restroom' action, then he goes to the toilet</p>
    <p>if you use a 'walking' action, then he walks somewhere</p>
    <p>if you use a 'hug_pet' action, then he is happy</p>
    <p>if you use a 'pet_status' action, then it will display the current characteristics of the pet from 0 to 100</p>
    <p>also every 10 minutes the pet's characteristics will decrease during the game</p>"
  end

  def pet_status
    parameters
  end

  def pet_needs
    @pet_message = 'Warning!'
    check_energy_health_mood
    check_hungry_thirst_dirty
    check_toilet_dreams
  end

  protected

  def method_missing(e)
    puts "#{e.to_s} unknown command. To get list of commands type help"
  end

  private

  def check_energy_health_mood 
    a = @params.slice(:health, :energy, :mood)
    nparam = a.select { |_, value| (1..50).include?(value) }
    if nparam == {} 
      pet_status
      @pet_message << "Your pet is doing well with health, energy, mood. "
    else
      nparam.each do |key, value|
        @pet_message <<  "#{key.capitalize} with score #{value}. Please, fix it. "
      end
    end
  end 


  def check_hungry_thirst_dirty
    b = @params.slice(:hungry, :thirst, :dirty)
    npa = b.select { |_, value| (11..100).include?(value) }
    if npa == {} 
      pet_status
      @pet_message << "Info! Your pet is doing well with hungry, thirst, dirty . "
    else
      npa.each do |key, value|
        @pet_message <<  "#{key.capitalize} with score #{value}. Please, fix it. "
      end
    end
  end 

  def check_toilet_dreams
    @pet_m = @toilet ? 'I need a toilet. ' : "I don't need a toilet. "
    dreams_message = @dreams ? 'I am still asleep. Wake me up. ' : "I don't need to sleep. "
    @pet_message << dreams_message
    @pet_message << @pet_m
  end

  def period_of_time
    loop do
      sleep(300)
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
        @pet_message = "Your pet has lost 5 lives. Your pet is dead.""\u{2620}"
      elsif @lifes == -1
        exit
      else
        @pet_message = "Your pet has lost one life. Now your pet has #{@lifes} lifes. Please check status of pet with 0 value and correct this value""\u{1F621}"
      end
    end
  end
end


print "Please, write the pet's name =>".green


name = gets.chomp
 
params_hash = { hungry: 10, health: 80, energy: 80, thirst: 10, mood: 80, dirty: 80 }
pet = Pet.new(name: name, params: params_hash, time: Time.now, dreams: false, lifes: 5, toilet: false)

selected = false
until selected
  print 'Do you have a cat or a dog?=>'.green
  pet_type = gets.chomp
  if %w[cat dog].include?(pet_type)
    image = pet.print_image(pet_type)
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

  content = PetAdapter.new(pet_params, pet.pet_message, name, image).to_s
  get_content(content, 'index', true)
  @a ||= Launchy.open('./tmp/index.html')
end
