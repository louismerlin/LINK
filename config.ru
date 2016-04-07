puts '~~~LinkIt~~~'

require 'sinatra'
require 'sequel'
require 'warden'
require 'yaml'
require 'tilt/erb'
require 'json'

CONFIG = YAML.load_file('config.yml')

use Rack::Session::Cookie, :secret => CONFIG['cookie_secret']

require './app.rb'
require './models.rb'
require './tests.rb' if settings.environment == :test

run LinkIt
