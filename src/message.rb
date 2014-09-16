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

      def add_checklist(creator, card, checklist)
        "'#{creator}'が'#{card}'カードに'#{checklist}'チェックリストを追加しました"
      end

      def remove_checklist(creator, card, checklist)
        "'#{creator}'が'#{card}'カードの'#{checklist}'チェックリストを削除しました"
      end

      def create_check_item(creator, card, checklist, checkitem)
        "'#{creator}'が'#{card}'カードの'#{checklist}'チェックリストに'#{checkitem}'を追加しました"
      end

      def delete_check_item(creator, card, checklist, checkitem)
        "'#{creator}'が'#{card}'カードの'#{checklist}'チェックリストから'#{checkitem}'を削除しました"
      end

      def update_check_item(creator, card, checklist, checkitem, old_checkitem)
        "'#{creator}'が'#{card}'カードの'#{checklist}'チェックリストの'#{old_checkitem}'を'#{checkitem}'に更新しました"
      end

      def update_check_item_state_on_card(creator, card, checklist, checkitem, state)
        state = state.eql?("complete") ? "完了" : "未完了"
        "'#{creator}'が'#{card}'カードの'#{checklist}'チェックリストの'#{checkitem}'を'#{state}'にしました"
      end

      def add_due_date(creator, card, list, new_due_date)
        "'#{creator}'が'#{list}'リストの'#{card}'カードの期日を'#{strftime_jst(new_due_date)}'に設定しました"
      end

      def update_due_date(creator, card, list, new_due_date, old_due_date)
        "'#{creator}'が'#{list}'リストの'#{card}'カードの期日を'#{strftime_jst(old_due_date)}'から'#{strftime_jst(new_due_date)}'に更新しました"
      end

      def remove_due_date(creator, card, list)
        "'#{creator}'が'#{list}'リストの'#{card}'カードの期日を削除しました"
      end

      def add_attachment(creator, card, attachment, url)
        "'#{creator}'が''#{card}'カードに添付ファイル'#{attachment}'を追加しました\n#{url}"
      end

      def delete_attachment(creator, card, attachment)
        "'#{creator}'が''#{card}'カードの添付ファイル'#{attachment}'を削除しました"
      end

    private
      def strftime_jst(datetime)
        Time.parse(datetime).in_time_zone('Tokyo').strftime('%Y/%m/%d %H:%M')
      end
    end
  end

  class List
    class << self
      def create(creator, list)
        "'#{creator}'が'#{list}'リストを作成しました"
      end

      def archive(creator, list)
        "'#{creator}'が'#{list}'リストをアーカイブしました"
      end

      def unarchive(creator, list)
        "'#{creator}'がアーカイブしていた'#{list}'リストを戻しました"
      end
    end
  end
end
