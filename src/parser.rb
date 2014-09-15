require 'active_support'
require 'active_support/core_ext'
require "#{File.expand_path(File.dirname(__FILE__))}/message"

class Parser
  class << self
    def parse(json)
      action_type = json['action']['type'].underscore
      if respond_to?(action_type, true)
        msg = __send__(action_type,  json)
      else
        p "Undefined action type : #{action_type}"
        p json.inspect
        msg = "Undefined action type named '#{action_type}'. Please contact the author..."
      end
      "[Trello Notification]\n#{msg}\n#{json['model']['url']}"
    end

  private
    def create_card(json)
      Message::Card.create(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def comment_card(json)
      Message::Card.comment(
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
        move_card(json)
      elsif json['action']['data']['old']['pos'].present? &&
            json['action']['data']['card']['pos'].present?
        if json['action']['data']['old']['pos'].to_f > json['action']['data']['card']['pos'].to_f
          up_card_position(json)
        else
          down_card_position(json)
        end
      elsif !json['action']['data']['old']['closed'].nil? &&
            !json['action']['data']['card']['closed'].nil?
        if json['action']['data']['old']['closed'] == false &&
            json['action']['data']['card']['closed'] == true
          archive_card(json)
        else
          unarchive_card(json)
        end
      else
        raise 'Undefined pattern in updateCard'
      end
    rescue => e
      p e
      p json.inspect
      'Undefined pattern in updateCard'
    end

    def move_card(json)
      Message::Card.move(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['listBefore']['name'],
        json['action']['data']['listAfter']['name']
      )
    end

    def up_card_position(json)
      Message::Card.up_position(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def down_card_position(json)
      Message::Card.down_position(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def archive_card(json)
      Message::Card.archive(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def unarchive_card(json)
      Message::Card.unarchive(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['list']['name']
      )
    end

    def add_member_to_card(json)
      Message::Card.add_member(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['member']['fullName']
      )
    end

    def remove_member_from_card(json)
      Message::Card.remove_member(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['member']['fullName']
      )
    end

    def add_label_to_card(json)
      Message::Card.add_label(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['text'].presence || json['action']['data']['value']
      )
    end

    def remove_label_from_card(json)
      Message::Card.remove_label(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['text'].presence || json['action']['data']['value']
      )
    end

    def update_list(json)
      if !json['action']['data']['old']['closed'].nil? &&
            !json['action']['data']['list']['closed'].nil?
        if json['action']['data']['old']['closed'] == false &&
            json['action']['data']['list']['closed'] == true
          archive_list(json)
        else
          unarchive_list(json)
        end
      end
    end

    def archive_list(json)
      Message::List.archive(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name']
      )
    end

    def unarchive_list(json)
      Message::List.unarchive(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name']
      )
    end
  end
end
