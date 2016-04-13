class LinkIt < Sinatra::Base

  get '/' do
    if warden_handler.authenticated?
      erb :'index', :layout => :'layout'
    else
      redirect '/login'
    end
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
    check_authentication
    current_user.channels.map{|l| l.values.merge("users": l.users.map{|l| {
      username:l[:username],
      first_name:l[:first_name],
      last_name:l[:last_name]}})}.to_json
  end

  get '/channels/:id' do
    User.all.first.channels.first.links.map{|l| l.values}.to_json
  end

  #
  # USER MANAGEMENT
  #

  get '/login' do
    erb :'login', :layout => :'layout'
  end

  get '/status' do
    warden_handler.authenticated?.to_json
  end

  post '/session' do
    warden_handler.authenticate!
    redirect '/'
  end

  get '/logout' do
    warden_handler.logout
    redirect '/'
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

  def current_user
    User.all[warden_handler.user]
  end

  def check_authentication
    if current_user==nil
      redirect '/login'
    end
  end

end
