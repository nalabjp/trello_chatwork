require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'eventmachine'
require "#{File.expand_path(File.dirname(__FILE__))}/app_logger"
require "#{File.expand_path(File.dirname(__FILE__))}/notifiers"
require "#{File.expand_path(File.dirname(__FILE__))}/hooks"

set :server, 'thin'

WEBHOOK_DELETE_MODE = ['true', true, 1, '1'].include?(ENV["WEBHOOK_DELETE_MODE"])

get '/' do
  'trello to chatwork'
end

post '/cb' do
  if WEBHOOK_DELETE_MODE
    any_status_code(410) # return status 410 means webhook delete
  else
    json = JSON.parse(request.body.read)
    @@notifiers.notify(json)
  end
end

head '/cb' do
  'for webhook'
end

def any_status_code(status)
  halt status.to_i, "status #{status.to_s}"
end

# create webhook
hooks = Hooks.new
EM::defer do
  retries = 0
  begin
    sleep 3
    hooks.create
    AppLogger.info('Created hooks!!')
  rescue => e
    AppLogger.info('Failed to create hooks...')
    AppLogger.info(e)
    puts e
    retries += 1
    retry if retries < 5
  end
end

# notifiers
@@notifiers = Notifiers.new(hooks.routes)

# delete webhook
# Require before `run Sinatra::Application`
at_exit do
  AppLogger.info('at_exit start')
  hooks.delete
  AppLogger.info('at_exit end')
end
