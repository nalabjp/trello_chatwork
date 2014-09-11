require 'active_support'
require 'active_support/core_ext'

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
      "'#{json['action']['memberCreator']['fullName']}'が'#{json['action']['data']['card']['name']}'カードを'#{json['action']['data']['list']['name']}'リストに作成しました"
    end

    def comment_card(json)
      "'#{json['action']['memberCreator']['fullName']}'が'#{json['action']['data']['list']['name']}'リストの'#{json['action']['data']['card']['name']}'カードに'#{json['action']['data']['text']}'とコメントしました"
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
      "'#{json['action']['memberCreator']['fullName']}'が'#{json['action']['data']['card']['name']}'カードを'#{json['action']['data']['listBefore']['name']}'リストから'#{json['action']['data']['listAfter']['name']}'リストに移動しました"
    end
  end
end