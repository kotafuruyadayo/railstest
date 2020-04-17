Rails.application.routes.draw do
  #get 'sessions/new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ### root(ログイン画面) ###
  root 'depologin#index'
  
  ### ログインのセッション ###
  get    '/login',   to: 'depologin#index'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  ### ログイン画面 ###
  get 'depologin', to: 'depologin#index'

  ### depomain ###
  # 一覧表示
  get 'depomain', to: 'depomain#index'
  # 一覧表示（更新）
  patch 'depomain', to: 'depomain#update'
  # 一覧EXCEL出力
  get 'depomain/excel', to: 'depomain#csv_download'
  # 一覧EXCEL出力
  get 'depomain/excelall', to: 'depomain#csv_download'

  # 詳細表示
  get 'depomain/:id', to: 'depomain#show'
  # 詳細表示(更新・削除)
  patch 'depomain/:id', to: 'depomain#dtbuttonclick'

  # データアップロード
  # 一覧表示
  get 'depoupload', to: 'depoupload#index'
  # CSV取込
  post 'depoupload', to: 'depoupload#data_import'

  # バックアップ戻し
  # 一覧表示
  get 'backupupload', to: 'backupupload#index'
  # CSV取込
  post 'backupupload', to: 'backupupload#data_import'

  ### maintenance ###
  # 一覧表示
  get 'maintenance', to: 'maintenance#index'
  # デポ先(表示)
  get 'maintedeposaki', to: 'maintedeposaki#index'
  # デポ先(新規登録or更新)
  post 'maintedeposaki', to: 'maintedeposaki#update'

  # ユーザ管理(表示)
  get 'mainte_user', to: 'mainte_user#index'
  # ユーザ管理（新規登録）
  get 'mainte_user/new' , to:'mainte_user#new'
  post 'mainte_user/new' , to:'mainte_user#new_exec'
  # ユーザ管理(詳細)
  get 'mainte_user/:id', to: 'mainte_user#show'
  # ユーザ管理(更新・削除)
  post 'mainte_user/:id', to: 'mainte_user#dtbuttonclick'

  # 荷姿セットアップ(表示)
  get 'maintenisugata', to: 'maintenisugata#index'
  # CSV取込
  post 'maintenisugata', to: 'maintenisugata#data_import'

  # 保管期数設定(表示)
  get 'maintehokankisuu', to: 'maintehokankisuu#index'


  ### 準備中画面 ###
  get 'jyunbichuu', to: 'jyunbichuu#index'
end
