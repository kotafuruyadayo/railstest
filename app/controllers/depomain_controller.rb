class DepomainController < ApplicationController

  #################### 一覧画面関連 ####################
  # 一覧表示
  def index
    # 検索処理
    @depomains,@depomains_cnt = commonsearch(1)
  end

  # 共通検索
  def commonsearch(kbn)
    #パラメータ設定
    @search_params = depomain_search_params
    #一覧、件数の取得
    return Depomain.search(@search_params \
                          ,authority_convert(currentuser_authorityget) \
                          ,kbn)
  end

  # 検索時のパラメータ設定（画面より取得）
  def depomain_search_params
    return params.permit(:depo_arrival_dateFrom \
                 ,:depo_arrival_dateTo \
                 ,:depo_shipment_dateFrom \
                 ,:depo_shipment_dateTo \
                 ,:keep_dayFrom \
                 ,:keep_dayTo \
                 ,:over_dayFrom \
                 ,:over_dayTo \
                 ,:seikei_num \
                 ,:section_code \
                 ,:depomst_id1 \
                 ,:depomst_id2 \
                 ,:depomst_id3 \
                 ,:fee_pointFrom \
                 ,:fee_pointTo \
                 ,:serial_num \
                 ,:product_name \
                 ,:fixed_date \
                 ,:page)
  end
  # 一覧画面にて更新
  def update
    @update_params = depomain_update_params
    Depomain.update_data(@update_params)

    redirect_to controller: 'depomain', action: 'index' #再表示
  end

  #更新時のパラメータ設定（画面の明細より、配列で取得）
  def depomain_update_params
    return params[:r]
  end
  
  # 詳細表示
  def show
    #データ詳細の取得
    @depomains_dt = Depomain.dtsearch(params[:id])
  end

  # 詳細画面にてボタンクリック時の処理 ※押されたボタンにより処理を切り分け
  def dtbuttonclick
    if params[:deletebutton] 
      # 削除時の処理
      deleteshow
    else
      # 更新時の処理
      updateshow
    end
  end

  #CSV出力関連 参考URL:https://qiita.com/geshi/items/2ccf8cc2ab45045421b5
  def csv_download
    #一覧、件数の取得
    @depomains_data,@depomains_cnt = commonsearch(2)
    #CSVデータ設定
    @csv_data = Depomain.csv_data(@depomains_data)
    #CSV出力
    respond_to do |format|
      filename = ERB::Util.url_encode('DepoDownload_'+ Time.now.strftime("%Y%m%d_%H%M%S") +'.csv')
      # .csv
      format.csv { send_data @csv_data, filename: filename, type: :csv }
    end
    #★★★ データ更新の処理は、どこで実施するかも含めて実装方法を検討する ★★★
  end
  #################### 一覧画面関連 ####################

  #################### 詳細画面関連 ####################
  #詳細画面での更新
  def updateshow
    @update_params = depomain_update_params_dt
    Depomain.update_datashow(@update_params)

    redirect_to controller: 'depomain', action: 'index' #再表示
  end
  
  #更新時（詳細）のパラメータ設定（画面より取得）
  def depomain_update_params_dt
    return params.permit(:depo_cd \
                 ,:seikei_num \
                 ,:delivery_name1 \
                 ,:delivery_address1 \
                 ,:send_name1 \
                 ,:send_address1 \
                 ,:shipment_cnt \
                 ,:shipment_date \
                 ,:arrival_date \
                 ,:item_cd \
                 ,:serial_num \
                 ,:product_name \
                 ,:status \
                 ,:section_code \
                 ,:section_name1 \
                 ,:section_name2 \
                 ,:remarks_factory \
                 ,:sales_name \
                 ,:carrier_code \
                 ,:carrier_name \
                 ,:keep_division \
                 ,:over_day \
                 ,:fee_point \
                 ,:keep_day \
                 ,:over_day \
                 ,:depo_arrival_date \
                 ,:depo_shipment_date \
                 ,:packing_type \
                 ,:depo_shipment_cnt \
                 ,:delivery_trader \
                 ,:delivery_charge \
                 ,:delivery_car \
                 ,:delivery_name2 \
                 ,:delivery_address2 \
                 ,:remarks_depo \
                 ,:id_dt \
                 )
  end

  #詳細画面での削除
  def deleteshow
    Depomain.find(params[:id_dt]).delete
    redirect_to controller: 'depomain', action: 'index' #再表示
  end

  #################### 詳細画面関連 ####################
  # pdf出力関連
  def chouhyou
    #検索処理★テスト的に追加
    @depomains,@depomains_cnt = commonsearch(1)
    #検索処理★テスト的に追加
    respond_to do |format|
      format.html # show.html.erb
      format.pdf do

        # Thin ReportsでPDFを作成
        # 先ほどEditorで作ったtlfファイルを読み込む
        report = OrderPDF.create @depomains

        # ブラウザでPDFを表示する
        # disposition: "inline" によりダウンロードではなく表示させている
        send_data \
          report.generate, \
          filename:    "#{5}.pdf", \
          type:        "application/pdf", \
          disposition: "inline"
      end
    end
  end
end