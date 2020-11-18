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
        </div>
    STR
  end

  private

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
