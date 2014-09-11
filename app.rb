require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'eventmachine'
require "#{File.expand_path(File.dirname(__FILE__))}/notifiers"
require "#{File.expand_path(File.dirname(__FILE__))}/hooks"

set :server, 'thin'

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

# create webhook
hooks = Hooks.new
EM::defer do
  retries = 0
  begin
    sleep 3
    hooks.create
    p 'Created hooks!!'
  rescue
    p 'Failed to create hooks...'
    retries += 1
    retry if retries < 5
  end
end

# notifiers
notifiers = Notifiers.new(hooks.routes)

# delete webhook
# Require before `run Sinatra::Application`
at_exit do
  p 'at_exit start'
  hooks.delete
  p 'at_exit end'
end
