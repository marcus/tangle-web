class LinksController < ApplicationController
  def index
    respond_to do |format|
      format.json { render :json => Link.all.as_json }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Link.find(params[:id]).as_json }
    end
  end
end
