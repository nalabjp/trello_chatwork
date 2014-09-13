class Messaage
  class << self
    def create_card(full_name, card_name, list_name)
      "'#{full_name}'が'#{card_name}'カードを'#{list_name}'リストに作成しました"
    end

    def comment_card(full_name, card_name, list_name, data_text)
      "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードに'#{data_text}'とコメントしました"
    end

    def move_list(full_name, card_name, list_before, list_after)
      "'#{full_name}'が'#{card_name}'カードを'#{list_before}'リストから'#{list_after}'リストに移動しました"
    end

    def up_position(full_name, card_name, list_name)
      "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードの優先度を上げました"
    end

    def down_position(full_name, card_name, list_name)
      "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードの優先度を下げました"
    end
  end
end
