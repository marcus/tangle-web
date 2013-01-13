class NodesController < ApplicationController
  def index
    list = params[:ids] || [Node.first.id]
    respond_to do |format|
      format.html { @primary_node = Node.first.to_json }
      format.json {
        render :json => Node.find(list.split(",")).map{|n|n.to_json({:shallow => true})}
      }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).to_json }
    end
  end

end
