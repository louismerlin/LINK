class Boilerplate < Sinatra::Base
  register Sinatra::Reloader if settings.environment == :development
  get '/' do
    @breads = Bread.all.last(10)
    erb :'index', :layout => :'layout'
  end
end
