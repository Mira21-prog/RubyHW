require 'pry'

class PetAdapter
  attr_reader :params, :pet_message

  def initialize(params, pet_message)
    @params = params
    @pet_message = pet_message
  end

  def to_s
    <<-STR
        <div class='container'>
            <div class="alert alert-success" role="alert">
              #{pet_message_block}
            </div>

            <div class='row'>
                <div class='col-sm-8'>
                    <ul>
                        #{list_params}
                    </ul>
                </div>
                <div class='col-sm-4'>
                 <img src="https://cdn2.thecatapi.com/images/L_H7aef7m.jpg" class="img-fluid" alt="Responsive image">
                </div>
            </div>
        </div>
    STR
  end

  private

  def pet_message_block
    return '' unless pet_message

    <<-STR
      <div class="row">
        <div class="col-sm-12">#{pet_message}</div>
      </div>
    STR
  end

  def list_params
    str = ''
    params.each do |k, v|
      item = <<-LI
                <li class="list-unstyled">
                    <label>#{k}</label>
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
