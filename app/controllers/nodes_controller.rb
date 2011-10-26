class NodesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render :json => Node.all.as_json }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).as_json }
    end
  end

end
