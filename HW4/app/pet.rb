require "erb"
require 'pry'
require "./app/lib/logic"
require "rack"

class Pet
  include Logic
  
  def self.call(env)
    new(env).response&.finish
  end
  
  def initialize(env)
    @req = Rack::Request.new(env)
    @hungry = 40
    @health = 50
    @energy = 60
    @thirst = 50
    @mood = 55
    @dirty= 10
    @lifes = 5
    @message = "Hello"
  end

  def response 
    case @req.path 
    when '/'
      Rack::Response.new(render("form.html.erb"))
    when '/init'
      Rack::Response.new do |response|
        response.set_cookie('hungry', @hungry)
        response.set_cookie('health', @health)
        response.set_cookie('energy', @energy)
        response.set_cookie('thirst', @thirst)
        response.set_cookie('mood', @mood)
        response.set_cookie('dirty', @dirty)
        response.set_cookie('lifes', @lifes)
        response.set_cookie('name', @req.params['name']) 
        response.set_cookie('image', @req.params['image'])
        response.set_cookie('message',@message)
        response.redirect('/start')
      end 
    when "/play"
      return Logic.change_params(@req)
    when "/eat"
      return Logic.change_params(@req)
    when "/drink"
      return Logic.change_params(@req)
    when "/treat"
      return Logic.change_params(@req)
    when "/grooming"
      return Logic.change_params(@req)
    when "/walking"
      return Logic.change_params(@req)
    when '/start'
      Rack::Response.new(render("index.html.erb"))
    when '/end'
      Rack::Response.new('The end', 404)
      Rack::Response.new(render("end.html.erb"))
    end
  end

  def get(attr)
    @req.cookies["#{attr}"].to_i
  end

  def name
    name = @req.cookies['name'].delete(' ')
    name.empty? ? 'Pet' : @req.cookies['name']
  end
  def image
    @req.cookies['image']
  end

  def message
    @req.cookies['message']
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
