class LinkIt < Sinatra::Base

  get '/' do
    erb :'index', :layout => :'layout'
  end

  get '/channels' do
    '[{"id":0, "name":"Hugo"}, {"id":1, "name":"Louis"}]'
  end

  get '/channels/:id' do
    User.all.first.channels.first.links.map{|l| l.values}.to_json
  end
end
