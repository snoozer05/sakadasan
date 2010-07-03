require "count_table.rb"

class Sakada
  RESULT_NORMAL = "1"
  RESULT_TOO_MANY = "2"
  RESULT_TOO_LITTLE = "3"
  RESULT_ZERO = "9"

  #
  # 座布団処理をします。
  # param:twitterの本文（status）、発言者ID(from_id)
  # return:返信status
  #
  def carry_zabuton_by_tweet(status, from_id)
    request = get_request(status)
    return [] unless valid_request?(request)

    result = process_request(request, from_id)
    return [build_reply_status(result, from_id)]
  end

  private
  def get_request(status)
    status.scan(/@(\w+)\s*(\+\++|--+)/)
  end

  def valid_request?(request)
    request.size != 0 && request[0].size == 2
  end

  def process_request(request, from_id)
   userid, count = request[0][0], get_zabuton_count(request[0][1])
   if can_save_zabuton?(from_id, userid, count)
     if !have_zabuton?(userid) && count < 0
       return { :user_id => userid, :this_count => count, :result_count => 0, :res => RESULT_ZERO }
     else
       fixed_count = fixed_count(count)  #枚数補正
       model = save_zabuton(userid, fixed_count)
       return create_return_hash(model, count, fixed_count)
     end
   end
  end

  def build_reply_status(result, from_id)
    case result[:res]
    when RESULT_NORMAL
      return "@#{from_id} #{result[:user_id]}さんの座布団は#{result[:this_count].to_i.abs}枚#{result[:this_count].to_i<0 ? '減って':'増えて'}#{result[:result_count]}枚になりました！"
    when RESULT_TOO_MANY
      return "@#{from_id} #{result[:this_count].to_i.abs}枚増やそうとしましたが、さかださんが座布団を落としたので、#{result[:user_id]}さんの座布団は#{result[:fixed_count].to_i.abs}枚だけ増えて#{result[:result_count]}枚になりました！"
    when RESULT_TOO_LITTLE
      return "@#{from_id} #{result[:this_count].to_i.abs}枚減らそうとしましたが、さかださんが運びきれず、#{result[:user_id]}さんの座布団は#{result[:fixed_count].to_i.abs}枚だけ減って#{result[:result_count]}枚になりました！"
    when RESULT_ZERO
      return "@#{from_id} #{from_id}さん！#{result[:user_id]}さんの座布団はもうゼロよ！"
    end
  end

  def create_return_hash(model, count, fixed_count)
    if count == fixed_count
      return { :user_id => model.user_id, :this_count => count, :result_count => model.count, :res => RESULT_NORMAL }
    elsif count != fixed_count && count>0
      return { :user_id => model.user_id, :this_count => count, :fixed_count => fixed_count, :result_count => model.count, :res => RESULT_TOO_MANY }
    elsif count != fixed_count && count<0
      return { :user_id => model.user_id, :this_count => count, :fixed_count => fixed_count, :result_count => model.count, :res => RESULT_TOO_LITTLE }
    end
  end

  def have_zabuton?(userid)
    model = CountTable.find_by_user_id(userid)
    return (model.nil? || model.count == 0) ? false : true
  end

  def can_save_zabuton?(from_id, to_id, count)
    (from_id != to_id) || (from_id == to_id && count < 0)
  end

  def save_zabuton(userid, count)
    model = CountTable.find_by_user_id(userid) || CountTable.new(:user_id => userid, :count => 1)
    model.count += count
    model.save!
    return model
  end

  def get_zabuton_count(countstr)
    count = 0
    if countstr[/\+/]
      count += countstr.size - 1
    elsif countstr[/-/]
      count -= countstr.size - 1
    end
    return count
  end

  def fixed_count(count)
    if count.abs>4
      fixed = rand(4)+1
      if count < 0
        return -fixed
      else
        return fixed
      end
   end
   return count
  end

end
