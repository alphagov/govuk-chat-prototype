class ExperimentBController < ApplicationController
  def index
    @view = params[:view]
  end

  def new
    # @view = params[:view]
    redirect_to new_chat_path(view: params[:view])
  end
end
