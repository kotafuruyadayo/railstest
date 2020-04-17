class MaintedeposakiController < ApplicationController
  def update
    if !(depomsts_params[:sin_meishou].present?) and !(params[:depomst_id1].eql?("0")) then
      #削除の処理
      Depomst.depomstdelete(depomsts_params)
    else
      if params[:depomst_id1].eql?("0") then
        #新規登録時の処理
        Depomst.depomstinsert(depomsts_params)
      else
        #更新の処理
        Depomst.depomstupdate(depomsts_params)
      end
    end

    #再表示
    redirect_to controller: 'maintedeposaki', action: 'index'
  end

  def depomsts_params
    params.permit(:depomst_id1 \
                 ,:sin_meishou \
    )
  end
end
