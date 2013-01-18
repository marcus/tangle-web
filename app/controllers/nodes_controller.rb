class NodesController < ApplicationController
  def index
    list = params[:ids] || [Node.first.id]
    respond_to do |format|
      format.html { @primary_node = Node.first.to_json }
      format.json {
        nodes = Node.find(list.split(",")).map{|n|n.to_json({:shallow => true})}
        if !nodes.is_a?(Array)
          nodes = [nodes]
        end
        render :json => nodes
      }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).to_json }
    end
  end

end
