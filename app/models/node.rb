class Node < ActiveRecord::Base
  include Extensions::UUID

  has_many :links, :foreign_key => :node_uuid

  has_many :children_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'child'"
  has_many :parent_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'parent'"
  has_many :sibling_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'sibling'"

  has_many :relationships, :through => :links, :source => :node

  has_many :children, :through => :children_links, :source => :parent_node
  has_many :parents, :through => :parent_links, :source => :child_node
  has_many :siblings, :through => :sibling_links, :source => :sibling_node

  def to_json(options={})
    n = {
      :uuid => uuid,
      :title => title,
      :description => description,
      :child_uuids => children_links.map{|l|l.uuid},
      :parent_uuids => parent_uuids.map{|l|l.uuid},
      :sibling_uuids => sibling_uuids.map{|l|l.uuid}
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

end
