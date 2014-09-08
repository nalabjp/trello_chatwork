require "#{File.expand_path(File.dirname(__FILE__))}/app"
require "#{File.expand_path(File.dirname(__FILE__))}/hooks"
run Sinatra::Appliction

# create webhook
hooks = Hooks.new
hooks.create

# notifiers
notifiers = Notifiers.new(hooks.routes)

# delete webhook
# Require before `run Sinatra::Application`
at_exit do
  p 'at_exit start'
  hooks.delete
  p 'at_exit end'
end
