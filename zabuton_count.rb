require "count_table.rb"

class ZabutonCount
  RESULT_NOMAL = "1"
  RESULT_TOO_MANY = "2"
  RESULT_TOO_LITTLE = "3"
  RESULT_ZERO = "9"
  
  #
  # 座布団処理をします。
  # param:twitterの本文（status）、発言者ID(from_id)
  # return:返信status
  #
  def get_zabuton(status, from_id)
    result = check(status, from_id)
    if !result.nil?
      case result[:res]
      when RESULT_NOMAL
        return "#{from_id}さんが#{result[:this_count].to_i.abs}枚#{result[:this_count].to_i<0 ? '減らした':'増やした'}ので、#{result[:user_id]}さんの座布団は#{result[:result_count]}枚になりました！"
      when RESULT_TOO_MANY
        return "#{from_id}さんが#{result[:this_count].to_i.abs}枚増やしたそうとしましたが、さかださんが座布団を落としたので、#{result[:user_id]}さんの座布団は#{result[:fixed_count].to_i.abs}枚だけ増えて#{result[:result_count]}枚になりました！"
      when RESULT_TOO_LITTLE
        return "#{from_id}さんが#{result[:this_count].to_i.abs}枚減らそうとしましたが、さかださんが運びきれず、#{result[:user_id]}さんの座布団は#{result[:fixed_count].to_i.abs}枚だけ減って#{result[:result_count]}枚になりました！"
      when RESULT_ZERO
        return "#{from_id}さん！#{result[:user_id]}さんの座布団はもうゼロよ！"
      end
    end
    return nil
  end

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
         if count.abs > 4
           fixed_count = fixed_count(count) 
         else
           fixed_count = count
         end
         model = save_zabuton(userid, fixed_count)
         if !model.nil? && count == fixed_count
           return {:user_id=>model.user_id, :this_count=>count, :result_count=>model.count, :res=>RESULT_NOMAL}
         elsif !model.nil? && count != fixed_count && count>0
           return {:user_id=>model.user_id, :this_count=>count, :fixed_count=>fixed_count, :result_count=>model.count, :res=>RESULT_TOO_MANY}
         elsif !model.nil? && count != fixed_count && count<0
           return {:user_id=>model.user_id, :this_count=>count, :fixed_count=>fixed_count, :result_count=>model.count, :res=>RESULT_TOO_LITTLE}
         else
           return {:user_id=>userid, :this_count=>count, :result_count=>0, :res =>RESULT_ZERO }
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
    model = CountTable.find_by_user_id(userid)
    if !model.nil?
      if model.count == 0 && count < 0
        return nil
      else
        model.count += count 
      end
    else
      model = CountTable.new
      model.user_id = userid
      model.count = 1 + count 
    end
    model.count = 0 if model.count < 0
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

  #
  # 座布団の数を1～4枚の間で補正します。
  # マイナス値の場合は、-1～-4の間で補正します。
  #
  def fixed_count(count)
    fixed = rand(3)+1
    if count < 0
     return -fixed
    else
     return fixed
    end
  end 
end
