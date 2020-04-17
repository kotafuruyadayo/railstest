module ApplicationHelper
  include SessionsHelper
 
  #デポ先コンボボックス設定用
  def combo_deposaki
    results=Depomst.where(mst_type: 1)
    #権限によって内容を切り替える
    if authority_convert(currentuser_authorityget).eql?(0) then #ALL以外
    else
      results=results.where(['mst_id = ?', authority_convert(currentuser_authorityget)]) 
    end 
    return results.order("mst_id")
  end 

  #保管状態コンボボックス設定用
  def combo_hokanjyoutai
    return Depomst.where(mst_type: 2).order("mst_id desc")
  end 

  #荷姿コンボボックス設定用
  def combo_nisugata
    return Depomst.where(mst_type: 3).order("mst_id")
  end 
  #荷姿コンボボックス設定用(ALL抜き)
  def combo_nisugata_noall
    return Depomst.where(mst_type: 3).where.not(mst_id:0).order("mst_id")
  end 


  #デポ先メンテナンス、コンボボックス設定用
  def combo_deposakimente
      return Depomst.where(mst_type: 1).order("mst_id")
                    .select("depomsts.mst_id,case when depomsts.mst_cd = 'ALL' THEN '新規登録' ELSE depomsts.mst_cd END AS mst_cd ")
  end 
  
  #配送業者、コンボボックス設定用
  def combo_haisougyousha
    return Depomst.where(mst_type: 5).order("mst_id")
  end 

  #配送車種、コンボボックス設定用
  def combo_haisoushashu
    return Depomst.where(mst_type: 4).order("mst_id")
  end
end
