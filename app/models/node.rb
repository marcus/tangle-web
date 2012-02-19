class Node < ActiveRecord::Base
  include Extensions::UUID

  def to_json(options={})
    n = {
      :uuid => uuid,
      :title => title,
      :description => description,
      :child_uuids => child_uuids,
      :parent_uuids => parent_uuids,
      :sibling_uuids => sibling_uuids
    }
    n.merge!(relationships_json)
    n.to_json
  end

  def relationships_json
    {
      :parents => parents,
      :children => children,
      :siblings => siblings
    }
  end

  def parents
    parent_uuids ? parent_uuids.map{|p| Node.find(p) } : []
  end

  def siblings
    sibling_uuids ? sibling_uuids.map{|s| Node.find(s) } : []
  end

  def children
    child_uuids ? child_uuids.map{|c| Node.find(c) } : []
  end

end
