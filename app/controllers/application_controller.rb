class ApplicationController < ActionController::Base
  # 共通の処理はこちらに記載 #
  protect_from_forgery #CSRF対策のため、記載が必要 https://blog.willnet.in/entry/20080509/1210338845
  
  include SessionsHelper
  
  helper_method :authority_convert,:authority_convert_kami1,:currentuser_authorityget #VIEW等からコントローラを使用できるようにしたい場合に記載（この記載があると呼び出せるようになります）

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      redirect_to login_url
    end
  end

  #権限項目の切り出し（デポ）
  def authority_convert(auth)
    if auth.present? then
      return auth.slice(2,3).to_i
    else
      return nil
    end
  end 

  #権限項目の切り出し（更新権限）
  def authority_convert_kami1(auth)
    if auth.present? then
      return auth.slice(0,1)
    else
      return nil
    end
  end 

  def currentuser_authorityget
    if current_user.present? then
      return current_user.authority
    else
      return nil
    end
  end
end
