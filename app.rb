class LinkIt < Sinatra::Base
  register Sinatra::Reloader if settings.environment == :development || settings.environment == :test
  
  get '/' do
    erb :'index', :layout => :'layout'
  end
end
