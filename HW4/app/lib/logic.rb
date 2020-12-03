require "./app/pet"
module Logic 
    extend self

    OPTION = {play: { "health": 5, "hungry": -10, "mood": 5}, 
              eat: {"health": -12, "hungry": 5, "dirty":5},
              drink: {"health":5, "energy":-10, "mood":5},
              treat: {"health":5, "mood":-11, "thirst":5},
              grooming: {"health":5, "energy":-8},
              walking: {"mood":11, "thirst":-5}
             }

    def change_params(req)
      Rack::Response.new do |response|
        request = req.path[1..-1].to_sym
        check_path(request)
        num = {}
        new_data = set_value(request,req, num)
        set_cookies(response, req, new_data)
        check_life(req, num, response)
      end
    end

    def check_path(request)
      return unless OPTION.keys.include?(request)
    end

    def set_value(request, req, num)
      OPTION[request].each do |k, v|
        num[k] = req.cookies["#{k}"].to_i + v
      end
      num
      check_value(num)
    end

    def set_cookies(response, req, new_data)
      new_data.each do |key, value|
        response.set_cookie("#{key}", value)
      end
      add_message(response, req)
      response.redirect('/start')
    end

    def add_message(response, req)
      response.set_cookie("message", "Pet: Thanks for playing! It was cool!") if req.path.include?("/play")
      response.set_cookie("message", "Pet: Yum Yum! It was delicious!") if req.path.include?("/eat")
      response.set_cookie("message", "Pet: Thanks! I feel very well") if req.path.include?("/drink")
      response.set_cookie("message", "Pet: I'm healthy now") if req.path.include?("/treat")
      response.set_cookie("message", "Pet: I have become very attractive! It was cool!") if req.path.include?("/grooming")
      response.set_cookie("message", "Pet: Thanks for walking! It was cool!") if req.path.include?("/walking")
    end 

    def check_value(num)
      num.each do |key, value|
        if num[key] > 100
          num[key] = 100
        elsif num[key] < 0 
          num[key] = 0
        else  
          num[key]
        end
      end
      num
    end

    def check_life(req, num, response)
      count = req.cookies["lifes"].to_i
      if num.value?(0)&&count > 0
        count = req.cookies["lifes"].to_i - 1
        redirected = '/start'
      elsif num.value?(0)&&count == 0
        count = 0
        redirected = '/end'
      else 
        count = req.cookies["lifes"].to_i
        redirected = '/start'
      end
      response.set_cookie("lifes", count)
      check_redirect(redirected, response)
    end


    def check_redirect(redirected, response)
      if redirected == "/end"
        response.redirect('/end')
      else  
        response.redirect('/start')
      end
    end

end