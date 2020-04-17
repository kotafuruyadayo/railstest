class BackupuploadController < ApplicationController
  def data_import
    #エラーメッセージのクリア
    flash[:danger] = ''
    # fileはtmpに自動で一時保存される
    if params[:file].present? && 
       params[:file].original_filename && 
       File.extname(params[:file].original_filename) == ".csv" # パラメータのoriginal_filenameでチェック
      then
        begin
          Depomain.data_import(params[:file])
          #再表示
          message = CONST_MSG::UPLOADOK #定数に直接文字を付与できなかったため、一回変数に退避
          flash[:danger] = message +'(' + params[:file].original_filename + ')'
          redirect_to action: 'index'
        rescue
          #エラー発生時
          flash[:danger] = CONST_MSG::ERRORABORT
          redirect_to action: 'index'
        end
    else
      # パラメータの条件ではねられたり、途中でエラーが起きたりした時はここまで来る
      flash[:danger] = CONST_MDG::ERRORUPLOADCSVSELECT
      redirect_to action: 'index'
    end
  end
end
