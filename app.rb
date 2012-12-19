require 'rubygems'
require 'sinatra'
require 'haml'
require 'less'
require 'coffee-script'

# Set Sinatra variables
set :app_file, __FILE__
set :root, File.dirname(__FILE__)
set :views, 'views'
set :public_folder, 'public'
set :haml, {:format => :html5} # default Haml format is :xhtml
set :port, 9395
Less.paths << (settings.views + "/less")

get '/' do
  haml :index
end

get '/styles' do
  content_type 'text/css', :charset => 'utf-8'
  less :"less/style"
end

get '/scripts' do
  coffee :"/coffee/main"
end