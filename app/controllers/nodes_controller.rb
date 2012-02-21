class NodesController < ApplicationController
  def index
    @primary_node = Node.first.to_json
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).to_json }
    end
  end

end
