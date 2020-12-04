require './app/pet'

use Rack::Reloader, 0
use Rack::Static, :urls => ["/public"]
use Rack::Auth::Basic do |user, password|
    user == "guest" && password == "afafaf123sg"
end
run Pet