class LinkIt < Sinatra::Base

  get '/' do
    erb :'index', :layout => :'layout'
  end

  #
  # API
  #

  ### USERS

  get '/users/:username' do
    @u = User.first(:username => params[:username])
    if @u != nil
      @u = @u.values
      {"first_name":@u[:first_name], "last_name":@u[:last_name], "username":@u[:username], "email":@u[:email]}.to_json
    end
  end

  post '/users' do
    if params[:email].match(/\A[^@]+@[^@]+\Z/) && params[:username] != "" && params[:password] != ""
      @user = User.new(first_name:params[:first_name], last_name:params[:last_name], email:params[:email], username:params[:username])
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.save
    end
  end

  ### CHANNELS

  get '/channels' do
    '[{"id":0, "name":"Hugo"}, {"id":1, "name":"Louis"}]'
  end

  get '/channels/:id' do
    User.all.first.channels.first.links.map{|l| l.values}.to_json
  end

  #
  # USER MANAGEMENT
  #

  get '/status' do
    warden_handler.authenticated?.to_json
  end

  post '/login' do
    warden_handler.authenticate!
  end

  get '/logout' do
    warden_handler.logout
  end

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = LinkIt
    manager.serialize_into_session {|user| user.id}
    manager.serialize_from_session {|id| User.get(id)}
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params["email"] || params["password"]
    end

    def authenticate!
      user = User.first(:email => params["email"])
      if user!=nil && user.authenticate(params["password"])!=nil
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  def warden_handler
    env['warden']
  end

  def check_authentication
    unless warden_handler.authenticated?
      redirect '/login'
    end
  end

  def current_user
    warden_handler.user
  end

end
