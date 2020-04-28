class OrderPDF
  # Classメソッドを定義
  def self.create depomains
    # Thin ReportsでPDFを作成
    # 先ほどEditorで作ったtlfファイルを読み込む
    # エラーが出る場合はVERに関係している場合があり　https://github.com/thinreports/thinreports-generator/issues/15
    report = Thinreports::Report.new layout: 'app/pdfs/test.tlf'

      # 1ページ目を開始
    report.start_new_page
      # 注文番号と注文日の値を設定
    # itemメソッドでtlfファイルのIDを指定し、
    # valueメソッドで値を設定します
    depomains.each do |f|
      report.page.item(:deposaki).value(f.depo_cd)
      report.page.item(:seikei).value(f.seikei_num)
    end
    #report.page.item(:qr_code).src(barcode(:qr_code, '4512345'))
    #バーコード出力参考：https://github.com/thinreports/thinreports-examples/blob/master/barcode/barcode.rb
    report.page.item(:qr_code).src(barcode(:qr_code, 'http://www.thinreports.org/', ydim: 5, xdim: 5))
    # JAN13
    report.page.item(:jan_13).src(barcode(:ean_13, '491234567890'))
    # JAN8
    report.page.item(:jan_8).src(barcode(:ean_8, '4512345'))
    ### 追加部分 開始 ###
    # テーブルの値を設定
    # list に表のIDを設定する(デフォルトのID値: default)
    # add_row で列を追加できる
    # ブロック内のrow.valuesで値を設定する
    depomains.each do |item|
      report.list(:default).add_row do |row|
        row.values depo_cd:    item.depo_cd,
                   seikei_num: item.seikei_num,
                   syukasu:    item.shipment_cnt
      end
    end
    ### 追加部分 終了 ###

    # ThinReports::Reportを返す
    return report
  end

  require 'bundler'
  Bundler.require
  require 'barby/barcode/ean_13'
  require 'barby/barcode/ean_8'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'
  #バーコード等表示用
  def self.barcode(type, data, png_opts = {})
    code = case type
    when :ean_13
      Barby::EAN13.new(data)
    when :ean_8
      Barby::EAN8.new(data)
    when :qr_code
      Barby::QrCode.new(data)
    end
    StringIO.new(code.to_png(png_opts))
  end
end