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
      p "---------- debug ----------"
      p "json['action']['data']['old']['idList']: #{json['action']['data']['old']['idList']}"
      p "json['action']['data']['listAfter']: #{json['action']['data']['listAfter']}"
      p "json['action']['data']['listBefore']: #{json['action']['data']['listBefore']}"
      p "json['action']['data']['old']['pos']: #{json['action']['data']['old']['pos']}"
      p "json['action']['data']['card']['pos']: #{json['action']['data']['card']['pos']}"
      p "---------- debug ----------"
      if json['action']['data']['old']['idList'].present? &&
          json['action']['data']['listAfter'].present? &&
          json['action']['data']['listBefore'].present?
        move_list(json)
      elsif json['action']['data']['old']['pos'].present? &&
            json['action']['data']['card']['pos'].present?
        move_position(json)
      elsif !json['action']['data']['old']['closed'].nil? &&
            !json['action']['data']['card']['closed'].nil?
        if json['action']['data']['old']['closed'] == false &&
            json['action']['data']['card']['closed'] == true
          archive_card(json)
        else
          unarchive_card(json)
        end
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

    def move_position(json)
      if json['action']['data']['old']['pos'].to_f > json['action']['data']['card']['pos'].to_f
        up_position(json)
      else
        down_position(json)
      end
    end

    def up_position(json)
      Message.up_position(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def down_position(json)
      Message.down_position(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def archive_card(json)
      Message.archive_card(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def unarchive_card(json)
      Message.unarchive_card(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end
  end
end
