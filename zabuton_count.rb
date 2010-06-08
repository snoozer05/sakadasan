require "count_table.rb"

class ZabutonCount
  #
  # 座布団処理をします。
  # param:twitterの本文（status）、発言者ID(from_id)
  # return:返信status
  #
  def get_zabuton(status, from_id)
    result = check(status, from_id)
    if !result.nil?
      if result[:res] == true
        return "#{from_id}さんが#{result[:this_count].to_i.abs}枚#{result[:this_count].to_i<0 ? '減らした':'増やした'}ので、#{result[:user_id]}さんの座布団は#{result[:result_count]}枚になりました！"
      else
        return "#{from_id}さん！#{result[:user_id]}さんの座布団はもうゼロよ！"
      end
    end
    return nil
  end

  private
  #
  # 座布団をあげたかどうかチェックします。
  # 座布団をあげている場合は、座布団計算をします。
  # param:twitterの本文(status)、発言者ID(from_id)
  # return {[座布団対象id],[座布団の数]}
  #
  def check(status, from_id)
   param = status.scan(/@(\w+)\s*(\+\++|--+)/)
   if param.size != 0
     if param[0].size == 2
       userid = param[0][0]
       countstr = param[0][1]
       count = get_count(countstr)
       if userid != from_id || (userid == from_id && count<0)
         model = save_zabuton(userid, count)
         if !model.nil?
           return { :user_id => model.user_id,:this_count=>count, :result_count => model.count , :res => true }
         else
           return { :user_id => userid ,:this_count=>count, :result_count => 0, :res => false }
         end
       end
     end
   end
   return nil
  end

  #
  # DBに値を格納します。
  # 存在しないIDの場合は新規に登録します。
  #
  def save_zabuton(userid, count)
    model = CountTable.find_by_user_id(userid) || CountTable.new(:user_id => userid, :count => 1)
    model.count += count
    model.save!
    return model
  end

  #
  # 座布団を数えます。
  #
  def get_count(countstr)
    count = 0
    if countstr[/\+/]
      count += countstr.size - 1
    elsif countstr[/-/]
      count -= countstr.size - 1
    end
    return count
  end
end
