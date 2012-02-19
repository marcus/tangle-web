class Node < ActiveRecord::Base
  include Extensions::UUID

  def to_json
    {
      :uuid => uuid,
      :title => title,
      :description => description
    }.to_json
  end

  def parents
    parent_uuids.map{|p| Node.find(p) }
  end

  def siblings
    sibling_uuids.map{|s| Node.find(s) }
  end

  def children
    child_uuids.map{|c| Node.find(c) }
  end

end
