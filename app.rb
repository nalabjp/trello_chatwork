require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require "#{File.expand_path(File.dirname(__FILE__))}/notifiers"

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
