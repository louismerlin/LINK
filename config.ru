puts '~~~LinkIt~~~'

require 'sinatra'
require 'sequel'
require 'yaml'
require 'tilt/erb'
require "sinatra/reloader" if settings.environment == :development || settings.environment == :test

CONFIG = YAML.load_file('config.yml')

use Rack::Session::Cookie, :secret => CONFIG['cookie_secret']

require './models.rb'
require './tests.rb' if settings.environment == :test
require './app.rb'

run LinkIt
