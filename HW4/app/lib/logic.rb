require "./app/pet"
module Logic 
    
    def self.change_params(req)
      Rack::Response.new do |response|
        options = {play: { "health": 5, "hungry": -10, "mood": 5}, 
                  eat: {"health": -12, "hungry": 5, "dirty":5},
                  drink: {"health":5, "energy":-10, "mood":5},
                  treat: {"health":5, "mood":-11, "thirst":5}
                  }

        request = req.path.delete "/"
        re = request.to_sym
        return unless options.keys.include?(re)
   
        options[re].each do |key, value|
          num = req.cookies["#{key}"].to_i + value + rand(0..10)
          response.set_cookie("#{key}", num)
          if num >= 100
            num = 100
            response.set_cookie("#{key}", num)
          elsif num <= 0
            num = 0
            response.set_cookie("#{key}", num)
          end


          select_option = req.cookies.slice("hungry", "health", "thirst", "mood", "dirty")
          values = select_option.select { |_, value| value.to_i.zero? }
          redirected = if req.cookies["lifes"].to_i <=0
            response.redirect('/end')
          elsif values.size.positive?
            count = req.cookies["lifes"].to_i - 1
            response.set_cookie("lifes", count)
            response.redirect('/start')
            response.redirect('/start')
          else
            count = req.cookies["lifes"].to_i
            response.set_cookie("lifes", count)
            response.redirect('/start')
          end 
         if redirected == "/end"
          response.redirect('/end')
         else  
          response.redirect('/start')
         end

      end
    end
  end
end
