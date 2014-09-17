require 'active_support'
require 'active_support/core_ext'
require "#{File.expand_path(File.dirname(__FILE__))}/app_logger"
require "#{File.expand_path(File.dirname(__FILE__))}/message"

class Parser
  class << self
    def parse(json)
      begin
        action_type = json['action']['type'].underscore
        if respond_to?(action_type, true)
          message(__send__(action_type, json), json['model']['url'])
        else
          raise "Undefined action type : #{action_type}"
        end
      rescue => e
        AppLogger.error(e.inspect)
        AppLogger.debug(json.inspect)
        message("Undefined action type named '#{action_type}'. Please contact the author...", json['model']['url'])
      end
    end

  private
    def message(msg, url)
      {
        title: "Trello Notification",
        body: msg,
        footer: url
      }
    end

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
      if json['action']['data']['old'].has_key?('idList')
        move_card(json)
      elsif json['action']['data']['old'].has_key?('pos')
        if json['action']['data']['old']['pos'].to_f > json['action']['data']['card']['pos'].to_f
          up_card_position(json)
        else
          down_card_position(json)
        end
      elsif json['action']['data']['old'].has_key?('closed')
        if json['action']['data']['old']['closed'] == false &&
            json['action']['data']['card']['closed'] == true
          archive_card(json)
        else
          unarchive_card(json)
        end
      elsif json['action']['data']['old'].has_key?('due')
        if json['action']['data']['old']['due'].nil? &&
            !json['action']['data']['card']['due'].nil?
          add_due_date(json)
        elsif !json['action']['data']['old']['due'].nil? &&
              !json['action']['data']['card']['due'].nil?
          update_due_date(json)
        elsif !json['action']['data']['old']['due'].nil? &&
              json['action']['data']['card']['due'].nil?
          remove_due_date(json)
        end
      else
        raise 'Undefined pattern in updateCard'
      end
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

    def add_checklist_to_card(json)
      Message::Card.add_checklist(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name']
      )
    end

    def remove_checklist_from_card(json)
      Message::Card.remove_checklist(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name']
      )
    end

    def create_check_item(json)
      Message::Card.create_check_item(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name'],
        json['action']['data']['checkItem']['name']
      )
    end

    def delete_check_item(json)
      Message::Card.delete_check_item(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name'],
        json['action']['data']['checkItem']['name']
      )
    end

    def update_check_item(json)
      Message::Card.update_check_item(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name'],
        json['action']['data']['checkItem']['name'],
        json['action']['data']['old']['name']
      )
    end

    def update_check_item_state_on_card(json)
      Message::Card.update_check_item_state_on_card(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['checklist']['name'],
        json['action']['data']['checkItem']['name'],
        json['action']['data']['checkItem']['state']
      )
    end

    def add_due_date(json)
      Message::Card.add_due_date(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name'],
        json['action']['data']['card']['name'],
        json['action']['data']['card']['due']
      )
    end

    def update_due_date(json)
      Message::Card.update_due_date(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name'],
        json['action']['data']['card']['name'],
        json['action']['data']['card']['due'],
        json['action']['data']['old']['due']
      )

    end

    def remove_due_date(json)
      Message::Card.remove_due_date(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name'],
        json['action']['data']['card']['name']
      )
    end

    def add_attachment_to_card(json)
      Message::Card.add_attachment(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['attachment']['name'],
        json['action']['data']['attachment']['url']
      )
    end

    def delete_attachment_from_card(json)
      Message::Card.delete_attachment(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['card']['name'],
        json['action']['data']['attachment']['name']
      )
    end

    def create_list(json)
      Message::List.create(
        json['action']['memberCreator']['fullName'],
        json['action']['data']['list']['name']
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
