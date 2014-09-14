module Message
  class Card
    class << self
      def create(full_name, card_name, list_name)
        "'#{full_name}'が'#{card_name}'カードを'#{list_name}'リストに作成しました"
      end

      def comment(full_name, card_name, list_name, data_text)
        "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードに'#{data_text}'とコメントしました"
      end

      def move(full_name, card_name, list_before, list_after)
        "'#{full_name}'が'#{card_name}'カードを'#{list_before}'リストから'#{list_after}'リストに移動しました"
      end

      def up_position(full_name, card_name, list_name)
        "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードの優先度を上げました"
      end

      def down_position(full_name, card_name, list_name)
        "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードの優先度を下げました"
      end

      def archive(full_name, card_name, list_name)
        "'#{full_name}'が'#{list_name}'リストの'#{card_name}'カードをアーカイブしました"
      end

      def unarchive(full_name, card_name, list_name)
        "'#{full_name}'がアーカイブしていた'#{card_name}'カードを'#{list_name}'リストに戻しました"
      end

      def add_member(creator_name, card_name, member_name)
        "'#{creator_name}'が'#{member_name}'を'#{card_name}'カードのメンバーに追加しました"
      end

      def remove_member(creator_name, card_name, member_name)
        "'#{creator_name}'が'#{member_name}'を'#{card_name}'カードのメンバーから削除しました"
      end
    end
  end

  class List
    class << self
      def archive(full_name, list_name)
        "'#{full_name}'が'#{list_name}'リストをアーカイブしました"
      end

      def unarchive(full_name, list_name)
        "'#{full_name}'がアーカイブしていた'#{list_name}'リストを戻しました"
      end
    end
  end
end
