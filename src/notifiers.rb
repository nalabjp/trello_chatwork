require 'chatwork'
require 'active_support'
require 'active_support/core_ext'
require "#{File.expand_path(File.dirname(__FILE__))}/parser"

class Notifiers
  def initialize(routes)
    @routes = routes
    ChatWork.api_key ||= ENV['CHATWORK_TOKEN']
  end

  def notify(json)
    res = ChatWork::Message.create(room_id: @routes[json['model']['id']], body: parse(json))
    if res['message_id']
      p "Completed send message: https://www.chatwork.com/#!rid#{@routes[json['model']['id']]}-#{res['message_id']}"
    else
      p "Failed to send message..."
    end
  end

private
  def parse(json)
    Parser.parse(json)
  end
end
