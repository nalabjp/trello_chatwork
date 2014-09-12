require 'active_support'
require 'active_support/core_ext'
require "#{File.expand_path(File.dirname(__FILE__))}/message.rb"

class Parser
  class << self
    def parse(json)
      action_type = json['action']['type'].underscore
      if respond_to?(action_type, true)
        __send__(action_type, json)
      else
        p "Undefined action type : #{action_type}"
        p json.inspect
        "Undefined action type named '#{action_type}'. Please contact the author..."
      end
    end

  private
    def create_card(json)
      Message.create_card(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def comment_card(json)
      Message.comment_card(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name'],
        json['action']['data']['card']['name'],
        json['action']['data']['text']
      )
    end

    def update_card(json)
      if json['action']['data']['old']['idList'].present? &&
          json['action']['data']['listAfter'].present? &&
          json['action']['data']['listBefore'].present?
        move_list(json)
      else
        p 'Undefined pattern in updateCard'
        p json.inspect
        'Undefined pattern in updateCard'
      end
    rescue => e
      p e
      p json.inspect
      'Undefined pattern in updateCard'
    end

    def move_list(json)
      Message.move_list(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['listBefore']['name'],
        json['action']['data']['listAfter']['name']
      )
    end
  end
end
