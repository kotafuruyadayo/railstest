class Depomst < ApplicationRecord
  # 新規登録
  def self.depomstinsert(depomst_params)
    #mst_idの最大値を取得する
    depomst_max=Depomst.where(['mst_type = 1']).maximum(:mst_id) +1
    #データ登録
    depomst_insert = Depomst.create(mst_type: 1 \
                                   ,mst_id: depomst_max \
                                   ,mst_cd: depomst_params[:sin_meishou] \
                                )
    depomst_insert.save

  end

  # 更新
  def self.depomstupdate(depomst_params)
    #idを取得
    id_results=get_id(depomst_params[:depomst_id1])

    #データ更新
    Depomst.find(id_results[0].id).update(mst_cd: depomst_params[:sin_meishou] )
  end

  # 削除
  def self.depomstdelete(depomst_params)
    #idを取得
    id_results=get_id(depomst_params[:depomst_id1])

    #データ削除
    Depomst.find(id_results[0].id).delete
  end

  # レコードのID取得
  def self.get_id(depomsts_params)
    return Depomst.where(['mst_type = 1 and mst_id = ? ',depomsts_params]).select(" depomsts.id")
  end
end
