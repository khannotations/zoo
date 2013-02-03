require 'rubygems'
require 'sinatra'
require 'haml'
require 'coffee-script'

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
set :public_folder, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml

get '/' do
  haml :index
end

get '/styles' do
  content_type 'text/css', :charset => 'utf-8'
  scss :"scss/style"
end

get '/scripts' do
  coffee :"/coffee/main"
end