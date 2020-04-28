class User < ApplicationRecord
  has_secure_password

  # 検索
  def self.search()
    #最初に全件取得
    results=User.joins("LEFT OUTER JOIN depomsts depoM1 ON substr(users.authority,4,1) = depoM1.mst_id::text and depoM1.mst_type =1 ")
                .select("users.*,depoM1.mst_cd ")
  
    #件数の取得
    users_cnt = results.size
    #結果返却 ※ページに表示する件数を変更する場合は、per_pageの値を変更
    return results,users_cnt
  end
  
  # 更新
  def self.update_data(update_param)
    User.where(['id = ?', update_param[:id]]).update(email:update_param[:password],password: update_param[:password],password_confirmation: update_param[:passwordkakunin],authority: update_param[:kengen]+format('%03d', update_param[:depomst_id1]))
  end 

  # 新規登録
  def self.insert_data(update_param)
    #データ登録
    user_insert = User.create(name: update_param[:name]\
      ,email: update_param[:password] \
      ,password: update_param[:password] \
      ,password_confirmation: update_param[:passwordkakunin] \
      ,authority: update_param[:kengen] + format('%03d', update_param[:depomst_id1].to_i) \
    )
    user_insert.save
  end

  def self.updatelogininfo(update_param)
    User.where(['id = ?', update_param]).update(updated_at: Time.zone.now)
  end 
end
