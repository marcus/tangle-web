class Node < ActiveRecord::Base
  include Extensions::UUID

  def to_json(options={})
    n = {
      :uuid => uuid,
      :title => title,
      :description => description,
    }
    n.merge!(relationships_json) unless options[:shallow] == true
    n.to_json
  end

  def relationships_json
    {
      :parents => parents.map{|p| p.to_json(:shallow => true)},
      :children => children.map{|c|c.to_json(:shallow => true)},
      :siblings => siblings.map{|s|s.to_json(:shallow => true)}
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
