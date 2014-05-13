class NodesController < ApplicationController
  def index
    # TODO - sort alphabetically
    respond_to do |format|
      format.html { @primary_node = Node.first.to_json }
      format.json {
        if params[:q] && params[:q].length > 1
          nodes = Node.where('title ILIKE ?', "%#{params[:q]}%").limit(20)
        else
          list = params[:ids] || [Node.first.id]
          nodes = Node.find(list.split(",")).map{|n|n.to_json({:shallow => true})}
          if !nodes.is_a?(Array)
            nodes = [nodes]
          end
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
