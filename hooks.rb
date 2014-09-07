require 'trello'
require "#{File.expand_path(File.dirname(__FILE__))}/configuration"

class Hooks
  attr_reader :routes

  def initialize
    @routes = Hash[*ENV['TRELLO_TO_CHATWORK'].split(',')]
    @hooks = []
  end

  def create
    @routes.each do |key, val|
      hook = Trello::Webhook.create(
        description: "webhook in #{ENV['HEROKU_URL']}: Trello board #{key} to ChatWork room #{val}",
        id_model: key,
        callback_url: "#{ENV['HEROKU_URL']}/cb"
      )
      p "Create Webhook -> id: #{hook.id}"
      @hooks.push(hook)
    end
  end

  def delete
    @hooks.each do |hook|
      p "Delete Webhook -> id: #{hook.id}"
      Trello::Webhook.find(hook.id).delete
    end
  end
end
