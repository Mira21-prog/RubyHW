require 'pry'

class PetAdapter
  attr_reader :params, :pet_message

  def initialize(params, pet_message, name, image)
    @params = params
    @pet_message = pet_message
    @name = name
    @image = image
  end

  def to_s
    <<-STR
        <div class='container'>
          <br>
            #{pet_name}
            <div class="alert alert-success" role="alert">
              #{pet_message_block}
            </div>

            <div class='row'>
                <div class='col-sm-8'>
                    <ul>
                        #{list_params}
                    </ul>
                </div>
                  #{get_image}
            </div>
            <br>
            <hr>
            <div class='row'>
              <div class="col-sm-12">
              #{add_button_help}
              </div>
            </div>
        </div>
    STR
  end

  private

  def add_button_help
    c = <<-SRC
      <button class="btn btn-success" type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
        HELP
      </button>
      <div class="collapse" id="collapseExample">
        <div class="card card-body bg-light">
        <p>If you use a 'play' action, then you will improve his <strong>health</strong>, but decreases <strong>energy</strong> and increases <strong>hungry, dirty, thirst</strong>.</p>
        <p>If you use a 'eat' action, then you will improve his <strong>health</strong>, <strong>mood</strong> but decreases <strong>energy</strong> and <strong>hungry</strong>, <strong>thirst</strong>.</p>
        <p>If you use a 'drink' action, then you will improve his <strong>health</strong> but decreases <strong>mood</strong> and <strong>thirst</strong>.</p>
        <p>If you use a 'treat' action, then you will improve <strong>all parameters</strong>.</p>
        <p>If you use a 'dream' action, then you will decreases <strong>all parameters</strong>.</p>
        <p>If you use a 'awake' action, then you will decreases  <strong>energy</strong>, <strong>mood</strong>, but increases <strong>hungry</strong>, <strong>dirty</strong>.</p>
        <p>If you use a 'overwatch' action, then a random action will be performed.</p>
        <p>If you use a 'grooming' action, then you will improve <strong>health</strong> and <strong>energy</strong>, decreases <strong>mood</strong>, <strong>hungry</strong>, <strong>dirty</strong>.</p>
        <p>If you use a 'restroom' action, then you will improve <strong>health</strong> and increases <strong>dirty</strong>, <strong>thirst</strong>.</p>
        <p>if you use a 'walking' action, then you will improve <strong>mood</strong> and increases <strong>dirty</strong>, and decreases <strong>energy</strong>.</p>
        <p>If you use a 'hug_pet' action, then you will improve <strong>mood</strong> and <strong>health</strong>.</p>
        <p>If you use a 'pet_status' action, then it will display the current characteristics of the pet from 0 to 100.</p>
        <p>Also every 10 minutes the pet's characteristics will decrease during the game.</p>
        </div>
      </div>
    SRC
    c
  end 

  def get_image
    if @image == 'cat'
      a = <<-SRC
      <div class='col-sm-4'>
        <img src="https://cdn2.thecatapi.com/images/3IWhPRL3a.jpg" class="img-fluid" alt="Responsive image">
      </div> 
      SRC
      a
    else 
      b = <<-SRC
      <div class='col-sm-4'>
        <img src="https://cdn2.thedogapi.com/images/H6UCIZJsc.jpg" class="img-fluid" alt="Responsive image">
      </div> 
      SRC
      b
    end
  end

  def pet_message_block
    return '' unless pet_message

    <<-STR
      <div class="row">
        <div class="col-sm-12">#{pet_message}</div>
      </div>
    STR
  end

  def pet_name 
    <<-STR
      <div class="alert alert-primary" role="alert">
            <h3/>Welcome, #{@name}!</h3>           
      </div>
    STR
  end

  def list_params
    str = ''
    params.each do |k, v|
      item = <<-LI
                <li class="list-unstyled">
                    <label class="text-capitalize font-weight-bold">#{k}</label> 
                    #{slider(v)}
                </li>
      LI
      str << item
    end
    str
  end

  def slider(value)
    <<-STR
        <div class="progress">
          <div class="progress-bar" role="progressbar" style="width: #{value}%" aria-valuenow="#{value}" aria-valuemin="0" aria-valuemax="100">#{value}</div>
        </div>
    STR
  end
end
