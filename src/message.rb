module Message
  class Card
    class << self
      def create(creator, card, list)
        "'#{creator}'が'#{card}'カードを'#{list}'リストに作成しました"
      end

      def comment(creator, card, list, text)
        "'#{creator}'が'#{list}'リストの'#{card}'カードに'#{text}'とコメントしました"
      end

      def move(creator, card, before, after)
        "'#{creator}'が'#{card}'カードを'#{before}'リストから'#{after}'リストに移動しました"
      end

      def up_position(creator, card, list)
        "'#{creator}'が'#{list}'リストの'#{card}'カードの優先度を上げました"
      end

      def down_position(creator, card, list)
        "'#{creator}'が'#{list}'リストの'#{card}'カードの優先度を下げました"
      end

      def archive(creator, card, list)
        "'#{creator}'が'#{list}'リストの'#{card}'カードをアーカイブしました"
      end

      def unarchive(creator, card, list)
        "'#{creator}'がアーカイブしていた'#{card}'カードを'#{list}'リストに戻しました"
      end

      def add_member(creator, card, member)
        "'#{creator}'が'#{member}'を'#{card}'カードのメンバーに追加しました"
      end

      def remove_member(creator, card, member)
        "'#{creator}'が'#{member}'を'#{card}'カードのメンバーから削除しました"
      end

      def add_label(creator, card, label)
        "'#{creator}'が'#{card}'カードに'#{label}'ラベルを追加しました"
      end

      def remove_label(creator, card, label)
        "'#{creator}'が'#{card}'カードの'#{label}'ラベルを削除しました"
      end
    end
  end

  class List
    class << self
      def archive(creator, list)
        "'#{creator}'が'#{list}'リストをアーカイブしました"
      end

      def unarchive(creator, list)
        "'#{creator}'がアーカイブしていた'#{list}'リストを戻しました"
      end
    end
  end
end
