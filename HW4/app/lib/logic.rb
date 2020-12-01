module Logic 
    
    def self.change_params(req)
      Rack::Response.new do |response|
        options = {play: { "health": 10, "hungry": -10, "mood": 10}, 
                  eat: {"health": 10, "hungry": -12, "dirty":20},
                  drink: {"health":10, "energy":10, "mood":10},
                  treat: {"health":20, "mood":20, "thirst":20}
                  }
        request = req.path.delete "/"
        re = request.to_sym
        return unless options.keys.include?(re)

        options[re].each do |key, value|
          count = req.cookies["#{key}"].to_i + value

          count = 100 if count > 100
          response.set_cookie(key, count)

        end
        response.redirect('/start')
    end
  end
end 