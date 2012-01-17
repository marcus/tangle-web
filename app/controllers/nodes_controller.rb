class NodesController < ApplicationController
  def index
    @nodes = Node.all
    @primary_node = Node.first

    respond_to do |format|
      format.json { render :json => Node.all.as_json }
      format.html { }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).as_json }
    end
  end

end
