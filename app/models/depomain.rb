class Depomain < ApplicationRecord
  include SessionsHelper

  #検索（一覧での絞込み）
  def self.search(search_param,authority_chg,kbn)
    #最初に全件取得して絞込みを実施
    results=depomainselect

    #デポ先(初期表示) ※絞込みを行うため、他の条件と少し異なる
    if !search_param[:depomst_id1].present? then
      if authority_chg.eql?(0) #ALL以外
      else
        results=results.where(['depoM1.mst_id = ?', authority_chg]) 
      end 
    #デポ先(検索時)
    else
      if search_param[:depomst_id1].eql?("0") then #ALL以外
      else
        results=results.where(['depoM1.mst_id = ?', search_param[:depomst_id1]]) 
      end 
    end
    #保管状態
    if search_param[:depomst_id2].eql?("10") or !search_param[:depomst_id2].present? then #ALL以外
    else
       results=results.where(['depoM2.mst_id = ?', search_param[:depomst_id2]])
    end
    #デポ入荷日(From,To) ※日付⇒文字列の変更を/の置換で検索にひっかけているが、あやしい(バックスラッシュはエスケープ)
    results=results.where(['depo_arrival_date >= ?', search_param[:depo_arrival_dateFrom].gsub(/\//,"")]) if search_param[:depo_arrival_dateFrom].present?
    results=results.where(['depo_arrival_date <= ?', search_param[:depo_arrival_dateTo].gsub(/\//,"")]) if search_param[:depo_arrival_dateTo].present?
    #デポ出荷日(From,To)
    results=results.where(['depo_shipment_date >= ?', search_param[:depo_shipment_dateFrom].gsub(/\//,"")]) if search_param[:depo_shipment_dateFrom].present?
    results=results.where(['depo_shipment_date <= ?', search_param[:depo_shipment_dateTo].gsub(/\//,"")]) if search_param[:depo_shipment_dateTo].present?
    #保管日数(From,To)
    results=results.where(['keep_day >= ?', search_param[:keep_dayFrom]]) if search_param[:keep_dayFrom].present?
    results=results.where(['keep_day <= ?', search_param[:keep_dayTo]]) if search_param[:keep_dayTo].present?
    #着日オーバ(From,To)
    results=results.where(['over_day >= ?', search_param[:over_dayFrom]]) if search_param[:over_dayFrom].present?
    results=results.where(['over_day <= ?', search_param[:over_dayTo]]) if search_param[:over_dayTo].present?
    #成契番号
    results=results.where(['seikei_num LIKE ?', "%#{search_param[:seikei_num]}%"]) if search_param[:seikei_num].present?
    #事部課
    results=results.where(['section_code LIKE ?', "%#{search_param[:section_code]}%"]) if search_param[:section_code].present?
    #荷姿
    if search_param[:depomst_id3].eql?("0") or !search_param[:depomst_id3].present? then #ALL以外
    else
      results=results.where(['depoM3.mst_id = ?', search_param[:depomst_id3]]) 
    end 
    #保管期数(From,To)
    results=results.where(['fee_point >= ?', search_param[:fee_pointFrom]]) if search_param[:fee_pointFrom].present?
    results=results.where(['fee_point <= ?', search_param[:fee_pointTo]]) if search_param[:fee_pointTo].present?
    #型番
    results=results.where(['serial_num LIKE ?', "%#{search_param[:serial_num]}%"]) if search_param[:serial_num].present?
    #名称
    results=results.where(['product_name LIKE ?', "%#{search_param[:product_name]}%"]) if search_param[:product_name].present?
    #指定日保管
    results=results.where([' (keep_division != \'2\' AND depo_shipment_date>=?) OR (keep_division = \'2\' AND depo_shipment_date is null) ', search_param[:fixed_date].gsub(/\//,"")]) if search_param[:fixed_date].present?

    #件数の取得(絞込み後のタイミングで取得)
    depomains_cnt = results.size
    
    if kbn.eql?(1) then 
      #結果返却 ※ページに表示する件数を変更する場合は、per_pageの値を変更
      return results.paginate(page: search_param[:page], per_page: 50) \
            ,depomains_cnt
    elsif kbn.eql?(2) then
      #結果返却 ※ページ区切り無し
      return results \
            ,depomains_cnt
    end
  end

  # 検索（詳細画面）
  def self.dtsearch(search_param_id)
    results=depomainselect
    results=results.where(['depomains.id = ?', search_param_id])
    #結果返却
    return results
  end

  #depomainデータ取得
  def self.depomainselect
    return Depomain.joins("LEFT OUTER JOIN depomsts depoM1 ON depomains.depo_cd = depoM1.mst_cd and depoM1.mst_type =1 ")
                   .joins("LEFT OUTER JOIN depomsts depoM2 ON depomains.keep_division = depoM2.mst_id::text and depoM2.mst_type =2 ")
                   .joins("LEFT OUTER JOIN depomsts depoM3 ON depomains.packing_type = depoM3.mst_cd and depoM3.mst_type =3 ")
                   .joins("LEFT OUTER JOIN depomsts depoM4 ON depomains.delivery_car = depoM4.mst_cd and depoM4.mst_type =4 ")
                   .joins("LEFT OUTER JOIN depomsts depoM5 ON depomains.delivery_trader = depoM5.mst_cd and depoM5.mst_type =5 ")
                   .select("depomains.*
                           ,depoM1.mst_cd as mst_cd1
                           ,depoM1.mst_id as mst_id1
                           ,depoM2.mst_cd as mst_cd2
                           ,depoM2.mst_id as mst_id2
                           ,depoM3.mst_cd as mst_cd3
                           ,depoM3.mst_id as mst_id3
                           ,depoM4.mst_cd as mst_cd4
                           ,depoM4.mst_id as mst_id4
                           ,depoM5.mst_cd as mst_cd5
                           ,depoM5.mst_id as mst_id5
                         ")
  end

  # 更新（一覧から）
  def self.update_data(update_param)
    #一覧のループ
    if update_param.present? then
      update_param.each{|key, value|
        #デポ入荷日が入力されていたら更新を実施
        if value[:r_depo_arrival_date].length != 0 then
          #保管状態区分判定
          update_keep_division = check_hokanjyoutai(value[:r_keep_division],value[:r_status])
          #保管日数算出
          update_keep_day = check_hokannissu(value[:r_depo_shipment_date],value[:r_depo_arrival_date],update_keep_division)
          #現地到着日オーバ日数算出
          update_over_day = check_genchitouchakuover(value[:r_depo_shipment_date],value[:r_arrival_date],update_keep_division)
          #保管期数算出
          update_fee_point = check_hokankisu(value[:r_depo_arrival_date],value[:r_depo_shipment_date],update_keep_division)
          #データ更新
          Depomain.where(['id = ?', value[:r_id]]).update(depo_arrival_date: value[:r_depo_arrival_date].gsub(/\//,"") \
                                                         ,keep_day: update_keep_day \
                                                         ,over_day: update_over_day \
                                                         ,fee_point: update_fee_point \
                                                         ,keep_division: update_keep_division \
                                                        )
        end
      }
    end 
  end

  # 更新（詳細から）
  def self.update_datashow(update_param)
    #保管状態区分判定
    update_keep_division = check_hokanjyoutai(update_param[:keep_division],update_param[:status])
    #デポ出荷年月日が入力された場合
    if update_param[:depo_shipment_date].length != 0 then
      if update_keep_division.eql?(2) then
        #2:保管中の場合
        update_keep_division = 9 #配送完了
      else
        if update_keep_division.eql?(9) then
          #9:配送完了の場合
          update_keep_division = 2 #保管中
        end
      end
    end

    #保管日数算出
    update_keep_day = check_hokannissu(update_param[:depo_shipment_date],update_param[:depo_arrival_date],update_keep_division)
    #現地到着日オーバ日数算出
    update_over_day = check_genchitouchakuover(update_param[:depo_shipment_date],update_param[:arrival_date],update_keep_division)
    #保管期数算出
    update_fee_point = check_hokankisu(update_param[:depo_arrival_date],update_param[:depo_shipment_date],update_keep_division)
    #データ更新
    Depomain.where(['id = ?', update_param[:id_dt]]).update(depo_arrival_date: update_param[:depo_arrival_date].gsub(/\//,"") \
                                                        ,keep_day: update_keep_day \
                                                        ,over_day: update_over_day \
                                                        ,fee_point: update_fee_point \
                                                        ,keep_division: update_keep_division \
                                                        ,remarks_factory: update_param[:remarks_factory] \
                                                        ,depo_shipment_date: update_param[:depo_shipment_date].gsub(/\//,"") \
                                                        ,packing_type: update_param[:packing_type] \
                                                        ,depo_shipment_cnt: update_param[:depo_shipment_cnt] \
                                                        ,delivery_trader: update_param[:delivery_trader] \
                                                        ,delivery_charge: update_param[:delivery_charge] \
                                                        ,delivery_car: update_param[:delivery_car] \
                                                        ,delivery_name2: update_param[:delivery_name2] \
                                                        ,delivery_address2: update_param[:delivery_address2] \
                                                        ,remarks_depo: update_param[:remarks_depo] \
    )
  end

  #保管状態区分判定
  def self.check_hokanjyoutai(r_keep_division,r_status)
    update_keep_division = r_keep_division
    #0:出荷予定、1:入荷待ちの場合
    if update_keep_division.eql?(0) or update_keep_division.eql?(1) then
      update_keep_division = 2 #保管中
    else
      #2:保管中の場合
      if update_keep_division.eql?(2) then
        if r_status.eql?(1) then
          #1:工場出荷前
          update_keep_division = 0 #入荷予定
        else
          #2:工場出荷後
          update_keep_division = 1 #入荷待ち
        end
      #9:出荷完了の場合
      elsif update_keep_division.eql?(9) then
        #showError("デポ入荷日が未入力です。 " . $HTTP_POST_VARS[('seikei_num' . $i)]);
      end
    end
    #結果返却
    return update_keep_division
  end

  #保管日数算出
  def self.check_hokannissu(r_depo_shipment_date_henkanmae,r_depo_arrival_date_henkanmae,r_keep_division)
    if r_depo_shipment_date_henkanmae.present? and r_depo_arrival_date_henkanmae.present? and !r_depo_shipment_date_henkanmae.eql?("NULL") and !r_depo_arrival_date_henkanmae.eql?("NULL") then
      #値が入っていたら続行(日付の変換を実施)
      r_depo_shipment_date = r_depo_shipment_date_henkanmae.to_date
      r_depo_arrival_date = r_depo_arrival_date_henkanmae.to_date
    else
      #入っていない場合は0を返却
      return 0
    end

    update_keep_division = r_keep_division
    update_keep_day = r_depo_shipment_date - r_depo_arrival_date
    
    if update_keep_division.eql?(2) then
      #2:保管中の場合
      update_keep_day = Date.today - r_depo_arrival_date #現在日付-デポ入荷日
    end
    #結果返却
    return update_keep_day
  end

  #現地到着日オーバ日数算出
  def self.check_genchitouchakuover(r_depo_shipment_date_henkanmae,r_arrival_date_henkanmae,r_keep_division)
    if r_depo_shipment_date_henkanmae.present? and  r_arrival_date_henkanmae.present? and !r_depo_shipment_date_henkanmae.eql?("NULL") then
      #値が入っていたら続行(日付の変換を実施)
      r_depo_shipment_date = r_depo_shipment_date_henkanmae.to_date
      r_arrival_date = r_arrival_date_henkanmae.to_date
    else
      #入っていない場合は0を返却
      return 0
    end
    update_keep_division = r_keep_division
    update_over_day = r_depo_shipment_date - r_arrival_date
    
    if update_keep_division.eql?(2) then
      #2:保管中の場合
      update_over_day = Date.today - r_arrival_date #現在日付-現地到着日
    end
    #結果返却
    return update_over_day
  end

  #保管期数算出
  def self.check_hokankisu(r_depo_arrival_date_henkanmae,r_depo_shipment_date_henkanmae,r_keep_division)
    if r_depo_arrival_date_henkanmae.present? and  r_depo_shipment_date_henkanmae.present? and !r_depo_arrival_date_henkanmae.eql?("NULL") and !r_depo_shipment_date_henkanmae.eql?("NULL")  then
      #値が入っていたら続行(日付の変換を実施)
      r_depo_arrival_date = r_depo_arrival_date_henkanmae.to_date
      r_depo_shipment_date = r_depo_shipment_date_henkanmae.to_date
    else
      #入っていない場合は0を返却
      return 0
    end

    update_keep_division = r_keep_division
    update_fee_point = 0 #保管期数
    #比較する日付の設定
    ymd = r_depo_arrival_date #デポ入荷日
    #9:出荷完了の場合
    if update_keep_division.eql?(9) then
      now_ymd = r_depo_shipment_date  #本日日付orデポ出荷日
    else
      now_ymd = Date.today
    end
    if ymd < now_ymd  then
      while ymd != now_ymd do
        #日付インクリメント
        ymd = ymd + 1
        #日付が01,11,21の場合は課金ポイント通過
        ymdday =ymd.mday
        if ymdday.eql?(1) or ymdday.eql?(11) or ymdday.eql?(21) then
          update_fee_point = update_fee_point + 1
        end
      end
    end
    #結果返却
    return update_fee_point
  end

  # CSV出力（データ出力ボタン）
  def self.csv_data(depomains_data)
    #明細データの設定
    depomain_csv = depomains_data
    #文字化けしないように https://qiita.com/nisshiy30/items/416d0ff41ddae669a5c5
    bom = "\uFEFF"
    #CSV生成
    csv_data = CSV.generate(bom) do |csv|
      # ヘッダ出力
      csv.add_row([CONST_TXT::DEPOSAKI \
                  ,CONST_TXT::SEIKEINO \
                  ,CONST_TXT::NOUNYUSAKIMEI \
                  ,CONST_TXT::NOUNYUSAKIJYUSHO \
                  ,CONST_TXT::HASOUSAKIMEI \
                  ,CONST_TXT::HASOUSAKIJYUSHO \
                  ,CONST_TXT::KOUJYOSYUKASU \
                  ,CONST_TXT::KOUJYOSYUKABI \
                  ,CONST_TXT::GENTITOUCHAKUBI \
                  ,CONST_TXT::HINMOKUCD \
                  ,CONST_TXT::KATABAN \
                  ,CONST_TXT::MEISYOU \
                  ,CONST_TXT::KOUJYOUSTS \
                  ,CONST_TXT::JIBUKA \
                  ,CONST_TXT::JIBMEISHOU \
                  ,CONST_TXT::KAMEISHOU \
                  ,CONST_TXT::KOUJYOUBIKO \
                  ,CONST_TXT::EIGYOTANTO \
                  ,CONST_TXT::UNSOUGYOUSHACD \
                  ,CONST_TXT::UNSOUGYOUSHAMEI \
                  ,CONST_TXT::HOKANJYOUTAIKBN \
                  ,CONST_TXT::DEPONYUKABI \
                  ,CONST_TXT::DEPOSYUKABI \
                  ,CONST_TXT::HOKANNISU \
                  ,CONST_TXT::CYAKUBIOVER \
                  ,CONST_TXT::DEPOSYUKARUISEKISU \
                  ,CONST_TXT::HAISOUGYOUSHA \
                  ,CONST_TXT::HAISOURYOUKIN \
                  ,CONST_TXT::HAISOUSHASHU \
                  ,CONST_TXT::HAISOUSAKIMEI \
                  ,CONST_TXT::HAISOUSAKIJYUUSHO \
                  ,CONST_TXT::DEPOBIKO \
                  ,CONST_TXT::NISUGATA \
                  ,CONST_TXT::HOKANKISU \
      ])

      # 明細出力
      depomain_csv.each do |depomain|
        csv << [depomain.depo_cd \
               ,depomain.seikei_num \
               ,depomain.delivery_name1 \
               ,depomain.delivery_address1 \
               ,depomain.send_name1 \
               ,depomain.send_address1 \
               ,depomain.shipment_cnt \
               ,depomain.shipment_date \
               ,depomain.arrival_date \
               ,depomain.item_cd \
               ,depomain.serial_num \
               ,depomain.product_name \
               ,depomain.status \
               ,depomain.section_code \
               ,depomain.section_name1 \
               ,depomain.section_name2 \
               ,depomain.remarks_factory \
               ,depomain.sales_name \
               ,depomain.carrier_code \
               ,depomain.carrier_name \
               ,depomain.keep_division \
               ,depomain.depo_arrival_date \
               ,depomain.depo_shipment_date \
               ,depomain.keep_day \
               ,depomain.over_day \
               ,depomain.depo_shipment_cnt \
               ,depomain.delivery_trader \
               ,depomain.delivery_charge \
               ,depomain.delivery_car \
               ,depomain.delivery_name2 \
               ,depomain.delivery_address2 \
               ,depomain.remarks_depo \
               ,depomain.packing_type \
               ,depomain.fee_point \
        ]
      end
    end
    return csv_data
  end

  #CSV取込（デポ入出荷・アップロード）
  def self.data_import(file)
    CSV.foreach(file.path, headers: true,encoding: "SJIS:UTF-8") do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      #depomain = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      #depomain.attributes = row.to_hash.slice(*updatable_attributes)
      
      #.stripのトリムは全角空白が削除されないようなので注意！！
      depomain = Depomain.create(
        # format使用時はto_iが必須です(8,9の変換の時にエラーとなる可能性があるため）！
        seikei_num: row[0] + format('%02d', row[1].strip.to_i),  \
        delivery_name1: row[2].strip, \
        delivery_address1: row[3].strip, \
        send_name1: row[4].strip, \
        send_address1: row[5].strip, \
        shipment_cnt: row[6].strip, \
        shipment_date: row[7].strip, \
        arrival_date: row[8].strip, \
        item_cd: format('%09d', row[9].strip.to_i), \
        serial_num: row[10].strip, \
        product_name: row[11].strip, \
        status: row[12].strip, \
        section_code: format('%04d', row[13].strip.to_i), \
        section_name1: row[14].strip, \
        section_name2: row[15].strip, \
        sales_name: row[16].strip, \
        carrier_code: format('%04d', row[17].strip.to_i), \
        carrier_name: row[18].strip, \
        depo_cd: row[19].strip, \
        packing_type: row[20].strip, \
        remarks_factory:  "", \
        #update_id: Depomain.current_user, \
        update_id: "CSV", \
        update_ap: "depoUploadPart" \
        # ★後で実装が必要
        #if($status[$dataCnt] === "1"){		//状態が1:出荷前の場合は保管状態区分=0:出荷予定
        #  $keep_division[$dataCnt] = "0";
        #}elseif($status[$dataCnt] === "2"){	//状態が2:出荷済みの場合は保管状態区分=1:入荷待ち
        #  $keep_division[$dataCnt] = "1";
      )

      # 保存する
      depomain.save
    end
  end

  #CSV取込（バックアップ戻し）
  def self.all_data_import(file)
    CSV.foreach(file.path, headers: true,encoding: "SJIS:UTF-8") do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      #depomain = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      #depomain.attributes = row.to_hash.slice(*updatable_attributes)
      
      #.stripのトリムは全角空白が削除されないようなので注意！！
      depomain = Depomain.create(
        # format使用時はto_iが必須です(8,9の変換の時にエラーとなる可能性があるため）！
        seikei_num: row[0] + format('%02d', row[1].strip.to_i),  \
        delivery_name1: row[2].strip, \
        delivery_address1: row[3].strip, \
        send_name1: row[4].strip, \
        send_address1: row[5].strip, \
        shipment_cnt: row[6].strip, \
        shipment_date: row[7].strip, \
        arrival_date: row[8].strip, \
        item_cd: format('%09d', row[9].strip.to_i), \
        serial_num: row[10].strip, \
        product_name: row[11].strip, \
        status: row[12].strip, \
        section_code: format('%04d', row[13].strip.to_i), \
        section_name1: row[14].strip, \
        section_name2: row[15].strip, \
        sales_name: row[16].strip, \
        carrier_code: format('%04d', row[17].strip.to_i), \
        carrier_name: row[18].strip, \
        depo_cd: row[19].strip, \
        packing_type: row[20].strip, \
        remarks_factory:  "", \
        #update_id: Depomain.current_user, \
        update_id: "CSV", \
        update_ap: "depoUploadPart" \
        # ★後で実装が必要
        #if($status[$dataCnt] === "1"){		//状態が1:出荷前の場合は保管状態区分=0:出荷予定
        #  $keep_division[$dataCnt] = "0";
        #}elseif($status[$dataCnt] === "2"){	//状態が2:出荷済みの場合は保管状態区分=1:入荷待ち
        #  $keep_division[$dataCnt] = "1";
      )

      # 保存する
      depomain.save
    end
  end
end
