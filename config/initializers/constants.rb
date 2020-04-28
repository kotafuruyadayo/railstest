#定数を記載 ★変更を反映させる際はサーバの再起動が必要
module CONST
  #画面表示文言
  if Rails.env == 'production'
    # 本番環境用の処理
    TITLE                    ="★本番★Furuyatest_デポ入出荷管理システム"
  else
    TITLE                    ="Furuyatest_デポ入出荷管理システム"
  end
  BACKUPUPLOAD1            ="<バックアップ戻し(★注意 DBの全データが入れ替わります)>"
  DEPOUPLOAD1              ="<工場出荷登録>"
  MAINTENISUGATA1          ="<荷姿セットアップ>"
  DEPOMAINSHOW1            ="0:出荷予定 1:入荷待ち 2:保管中 9:配送完了"
  DEPOMAINSHOW2            ="1:工場出荷前 2:工場出荷済"
  MAINTEUSER_KOUSIN        ="更新"
  MAINTEUSER_SANSHOU       ="参照"
  MAINTEUSER_KOUSINKENGEN  ="更新権限"
  MAINTEUSER_SANSHOUKENGEN ="参照権限"
  SESSIONGIRE              ="セッションが切れました。ログイン画面より、ログインしてください。"
  DEPOSAKIMEISHOU_KYU      ="デポ先名称（旧）"
  DEPOSAKIMEISHOU_SIN      ="デポ先名称（新）"
  TOUROKUJI                ="登録時"
  KOUSINJI                 ="更新時"
  SAKUJYOJI                ="削除時"
  MSG_TOUROKUJI            ="「デポ先名称(旧)」で「新規登録」を選択し、「デポ先名称(新)」に新たに登録するデポ先の名称を入力して下さい。"
  MSG_KOUSINJI             ="「デポ先名称(旧)」で変更するデポ先の名称を選択し、「デポ先名称(新)」に変更後のデポ先の名称を入力して下さい。"
  MSG_SAKUJYOJI            ="「デポ先名称(旧)」で削除するデポ先の名称を選択し、「デポ先名称(新)」は空白にして下さい。"
end 

module CONST_LINK
  #リンク名称
  LOGOUT                  ="ログアウト"
  LOGIN                   ="ログイン"
  SYOUSAI                 ="詳細"
  DATASHUTURYOKU          ="データ出力"
  KOUJYOUSHUKATOUROKU     ="工場出荷登録"
  BACKUP                  ="バックアップ"
  BACKUPMODOSI            ="バックアップ戻"
  MAINTENANCE             ="メンテナンス"
  DEPOSAKI                ="デポ先"
  USERKANRI               ="ユーザ管理"
  NISUGATASETUP           ="荷姿セットアップ"
  HOKANKISUUSET           ="保管期数設定"
end

module CONST_BTN
  #ボタン名称
  MODORU    ="【戻る】"
  JIKKOU    ="　　実　行　　"
  KOUSIN    ="　　更　新　　"
  SAKUJYO   ="　　削　除　　"
  KENSAKU   ="検索"
  CLEAR     ="入力クリア"
  NEW       ="新規登録"
  MAE       =" &lt 前へ"
  TUGI      ="次へ &gt"
end

module CONST_MSG
  #VIEWからのメッセージ
  MEISAIKAKUNIN        ="明細のデータを更新してもよろしいですか？"
  JIKKOUKAKUNIN        ="実行してもよろしいですか？"
  KOUSINKAKUNIN        ="更新してもよろしいですか？"
  SAKUJYOKAKUNIN       ="★注意★データを削除してもよろしいですか？"
  TOUROKUKAKUNIN       ="登録してもよろしいですか？"

  #アップロード用メッセージ
  UPLOADOK             ="【正常終了】アップロードが完了しました"
  ERRORUPLOADCSVSELECT ="★エラー：読み込むCSVを選択してください"
  ERRORABORT           ="取込処理が異常終了しました　※取込ファイルが正しいかどうか等、ご確認下さい"
end

module CONST_TXT
  #depomain系共通項目
  HOKANJYOUTAI            ="保管状態"
  SEIKEINO                ="成契番号"
  KOUJYOSYUKASU           ="工場出荷数"
  KOUJYOSYUKABI           ="工場出荷日"
  GENTITOUCHAKUBI         ="現地到着日"
  JIBUKA                  ="事部課コード"
  EIGYOTANTO              ="営業担当"
  DEPONYUKABI             ="デポ入荷日"
  DEPOSYUKABI             ="デポ出荷日"
  HOKANNISU               ="保管日数"
  CYAKUBIOVER             ="着日オーバ"
  NISUGATA                ="荷姿"
  HOKANKISU               ="保管期数"
  KATABAN                 ="型番"
  MEISYOU                 ="名称"
  SITEIBIHOKAN            ="指定日保管"
  NO                      ="No."

  UNSOUGYOUSHACD          ="運送業者コード"
  NOUNYUSAKIMEI           ="納入先名"
  UNSOUGYOUSHAMEI         ="運送業者名"
  NOUNYUSAKIJYUSHO        ="納入先住所"
  HOKANJYOUTAIKBN         ="保管状態区分"  #★要確認
  HASOUSAKIMEI            ="発送先名"
  HASOUSAKIJYUSHO         ="発送先住所"
  HINMOKUCD               ="品目コード"
  DEPOSYUKARUISEKISU      ="デポ出荷累積数"
  HAISOUGYOUSHA           ="配送業者"
  KOUJYOUSTS              ="工場状態"
  HAISOURYOUKIN           ="配送料金"
  HAISOUSHASHU            ="配送車種"
  JIBMEISHOU              ="事部名称"
  HAISOUSAKIMEI           ="配送先名"
  KAMEISHOU               ="課名称"
  HAISOUSAKIJYUUSHO       ="配送先住所"
  KOUJYOUBIKO             ="工場備考"
  DEPOBIKO                ="デポ備考"

  #user系共通項目
  USERID                  ="ユーザＩＤ"
  PASSWORD                ="パスワード"
  PASSWORDCONFIRM         ="パスワード（確認用）"
  KENGEN                  ="権限"
  SAISHUACCESS            ="最終アクセス日時"

  #共通系項目
  DEPOSAKI                ="デポ先"
  SOUDATA                 ="　総データ："
  KEN                     ="件"
end

module CLASS
  MODORU      ="modoru"
  TABLECENTER ="tablecenter"
end

module CONST_KENGEN
  UPD    ="0"
  REF    ="1"
  SADMIN ="9"
  ADMIN  = 0 #下3桁が000
end
