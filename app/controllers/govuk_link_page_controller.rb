class GovukLinkPageController < ApplicationController
  def index
    params[:view].present? ? @view = params[:view] : @view = 'b'
  end
end
