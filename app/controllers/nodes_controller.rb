class NodesController < ApplicationController
  def index
    # TODO - sort alphabetically
    respond_to do |format|
      format.html { @primary_node = Node.first.to_json }
      format.json {
        if params[:q] && params[:q].length > 1
          #nodes = Node.where('title ILIKE ?', "%#{params[:q]}%").limit(20)
          results = SearchResult.similar_to(params[:q]).limit(20)
          render :json => results, each_serializer: SearchResultSerializer
        else
          list = params[:ids] || [Node.first.id]
          nodes = Node.find(list.split(",")).map{|n|n.to_json({:shallow => true})}
          render :json => nodes
        end
      }
    end
  end

  def show
    respond_to do |format|
      format.json { render :json => Node.find(params[:id]).to_json }
    end
  end

end
