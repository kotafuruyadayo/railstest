class SessionsController < ApplicationController
  def new
    redirect_to root_url
  end

  def create
    # ユーザ名でデータ検索
    user1 =User.find_by(name: params[:session][:name].downcase)

    flash[:danger] = nil #初期化
    #データが取得できなかった場合にエラーとしない
    if user1.nil?
      #エラーメッセージ表示
      flash[:danger] = 'ログインに失敗しました（対象のユーザIDが存在しません）'
      redirect_to controller: 'depologin', action: 'index'
    else
      if user1.authenticate(params[:session][:password])
        log_in user1
        #最終アクセス日時を更新
        User.updatelogininfo(user1[:id])
        redirect_to controller: 'depomain', action: 'index'
      else
        #エラーメッセージ表示
        flash[:danger] = 'ログインに失敗しました（パスワードが違います）'
        redirect_to controller: 'depologin', action: 'index'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
