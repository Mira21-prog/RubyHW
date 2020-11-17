require_relative 'cat2'
require_relative 'color'
require_relative 'pet_adapter'
require 'content_flip'
require 'launchy'
require 'pry'

class Pet
  include ConsoleImage
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
      cat
    when 'dog'
      dog
    end
  end

  def play
    if @params[:mood] >= 100
      @pet_message = 'I dont want to play. Lets play some other time'
      puts pet_message
    else
      @params[:energy] -= 20
      @params[:health] += 5
      @params[:hungry] -= 3
      @params[:thirst] += 10
      @pet_message = 'I like to play! Played well!'
      puts pet_message
    end
  end

  def eat
    if @params[:hungry] <= 85
      @params[:mood] -= 10
      @params[:energy] -= 5
      @pet_message = "I don't want to eat."
      puts pet_message
    else
      @params[:hungry] -= 10
      @params[:health] += 5
      @params[:energy] -= 10
      @params[:thirst] += 10
      @toilet = true
      @pet_message = 'Yummy. Thank you for feeding'
      puts pet_message
    end
    check_life
    puts pet_message
  end

  def drink
    if @params[:thirst] >= 100
      @params[:mood] -= 10
      @pet_message = 'I don`t want to drink.'
    else
      @params[:health] += 5
      @params[:mood] += 5
      @params[:thirst] += 10
      @pet_message = "Thank you. Now I don't want to drink anymore"
    end
    check_life
    puts pet_message
  end

  def treat
    if @params[:health] >= 100
      @params[:mood] -= 10
      @pet_message = "I am well. Thanks"
    else
      @params[:health] += 50
      @params[:mood] += 10
      @params[:thirst] += 5
      @params[:hungry] += 10
      @params[:energy] += 10
      @pet_message = "Thank you. I'm healthy now"
    end
    check_life
    puts pet_message
  end

  def dream
    @dreams = true
    @params.each_with_object(@params) do |(key, _), hash|
      hash[key] += 5
    end
    check_life
    @pet_message = 'zzZ zzZ zzZ zzZ zzZ'
    puts pet_message
  end

  def awake
    @time = Time.now
    @dreams = false
    @params[:hungry] -= 3
    @params[:energy] -= 5
    @params[:mood] -= 5
    check_life
    @pet_message = 'Good morning!'
    puts pet_message
  end

  def mood
    if @params[:mood] >= 100
      @pet_message = 'I have a good mood'
    else
      @params[:mood] += 10
      @params[:health] += 10
      @params[:energy] += 10
      @params[:hungry] -= 3
      @pet_message = 'You improved my mood'
    end
    check_life
  end

  def overwatch
    arr = %i[play eat drink treat dream awake mood grooming clean walking hug_pet].sample
    send(arr)
  end

  def grooming
    if @params[:dirty] >= 90
      @pet_message = "Thanks. I'm beautiful now."
    else
      @params[:mood] += 8
      @params[:health] += 3
      @params[:energy] += 2
      @params[:hungry] -= 3
      @pet_message = "I'm very very beautiful."
    end
    check_life
  end

  def restroom
    @toilet = false
    check_life
    @pet_message = "I've done it."
  end

  def walking
    @params[:mood] += 10
    @params[:energy] -= 10
    check_life
    @pet_message = "Thank you for walking with me"
  end

  def hug_pet
    @params[:mood] += 10
    @params[:health] += 3
    check_life
    @pet_message = "Thanks. I am very happy"
  end

  def help
    @pet_message = "<h2>Help:</h2>
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
    nparam = @params.select { |_, value| (1..30).include?(value) }
    if nparam == {}
      pet_status
    else
      nparam.each do |key, value|
        @pet_message =  "Warning: I am #{key} with score #{value}. Please, improve it"
      end
    end
    @toilet ? 'I need a toilet'.red : "I don't need a toilet"
    @dreams ? 'I am still asleep. Wake me up'.red : "I don't need to sleep"
  end

  protected

  # def method_missing(e)
  #   puts "#{e.to_s} unknown command. To get list of commands type help"
  # end

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

        @pet_message = "Your pet has lost 5 lives. Your pet is dead."

        exit
      else
        @pet_message = "Your pet has lost one life. Now your pet has #{@lifes} lifes. Please check status of pet with 0 value and correct this value"
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
  print 'Enter command =>'
  option = gets.chomp
  pet.send(option)
  next unless pet.public_methods(false).include?(option.to_sym)

  pet_params = pet.pet_status

  content = PetAdapter.new(pet_params, pet.pet_message).to_s
  get_content(content, 'index', true)
  @a ||= Launchy::Browser.run('./tmp/index.html')
end
