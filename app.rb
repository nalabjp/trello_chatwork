require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require "#{File.expand_path(File.dirname(__FILE__))}/hooks"
require "#{File.expand_path(File.dirname(__FILE__))}/notifiers"

set :server, 'thin'

# create webhook
hooks = Hooks.new
hooks.create

# notifiers
notifiers = Notifiers.new(hooks.routes)

get '/' do
  'trello to chatwork'
end

post '/cb' do
  json = JSON.parse(request.body.read)
  notifiers.notify(json)
end

head '/cb' do
  'for webhook'
end

# delete webhook
# Require before `run Sinatra::Application`
at_exit do
  p 'at_exit start'
  hooks.delete
  p 'at_exit end'
end
