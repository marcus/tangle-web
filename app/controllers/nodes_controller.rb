class NodesController < ApplicationController
  def index
    @primary_node = Node.first
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).as_json }
    end
  end

end
