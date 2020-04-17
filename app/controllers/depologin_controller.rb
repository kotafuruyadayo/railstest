class DepologinController < ApplicationController
  def index
    render layout: false #application.html.erbを適用したくないため記載
  end
end
