class MainteUserController < ApplicationController
  def index
    #一覧、件数の取得
    @users,@users_cnt = User.search
  end

  def show
    #データ詳細の取得
    @users_dt = User.where(id: params[:id])
  end

  def new_exec
    @update_params = user_update_params
    User.insert_data(@update_params)

    #再表示
    redirect_to controller: 'mainte_user', action: 'index'
  end

  #詳細画面にてボタンクリック時の処理　※押されたボタンにより処理を切り分け
  def dtbuttonclick
    if params[:deletebutton] 
      # 削除時の処理
      deleteshow
    else
      # 更新時の処理
      updateshow
    end
  end

  def updateshow
    #新規登録or更新
    @update_params = user_update_params
    User.update_data(@update_params)

    #再表示
    redirect_to controller: 'mainte_user', action: 'index'
  end

  def deleteshow
    #削除
    User.find(params[:id]).delete
    #再表示
    redirect_to controller: 'mainte_user', action: 'index'
  end

  #更新時のパラメータ設定（画面の明細より取得）
  def user_update_params
    return params.permit(:id \
      ,:name \
      ,:password \
      ,:passwordkakunin \
      ,:depomst_id1 \
      ,:kengen)
  end
end
