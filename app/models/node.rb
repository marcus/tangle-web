class Node < ActiveRecord::Base
  include Extensions::UUID

  # has_many :links, :foreign_key => :node_uuid

  # has_many :children_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'child'"
  # has_many :parent_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'parent'"
  # has_many :sibling_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'sibling'"

  # has_many :relationships, :through => :links, :source => :node

  # has_many :children, :through => :children_links, :source => :parent_node
  # has_many :parents, :through => :parent_links, :source => :child_node
  # has_many :siblings, :through => :sibling_links, :source => :sibling_node

  # 1 = NodeA is parent of NodeB
  # 2 = NodeA is child of NodeB
  # 3 = siblings

  # Children
  # nodeB where nodeA = guid AND direction = 1
  # nodeA where nodeB = guid AND direction = 2
  #
  # Parents
  # nodeA where nodeB = guid AND direction = 1
  # nodeB where nodeA = guid AND direction = 2
  #
  # Siblings
  # nodeB where nodeA = guid AND direction = 3
  # nodeA where nodeB = guid AND direction = 3
  def children_links
    Link.where ['(node_a_uuid = ? AND direction = ?) OR (node_b_uuid = ? AND direction = ?)', uuid, 1, uuid, 2]
  end

  def child_uuids
    children_links.map{ |cl|
      cl.direction == 1 ? cl.node_b_uuid : cl.node_a_uuid
    }
  end

  def children
    Node.find_all_by_uuid child_uuids
  end

  def parent_links
    Link.where ['(node_b_uuid = ? AND direction = ?) OR (node_a_uuid = ? AND direction = ?)', uuid, 1, uuid, 2]
  end

  def parent_uuids
    parent_links.map { |pl|
      pl.direction == 1 ? pl.node_a_uuid : pl.node_b_uuid
    }
  end

  def parents
    Node.find_all_by_uuid parent_uuids
  end

  def sibling_links
    Link.where ['(node_a_uuid = ? AND direction = ?) OR (node_b_uuid = ? AND direction = ?)', uuid, 3, uuid, 3]
  end

  def sibling_uuids
    sibling_links.map { |sl|
      sl.node_a_uuid == uuid ? sl.node_b_uuid : sl.node_a_uuid
    }
  end

  def siblings
    Node.find_all_by_uuid sibling_uuids
  end

  def to_json(options={})
    n = {
      :uuid => uuid,
      :title => title,
      :description => description
    }
    n.merge!(relationship_uuids)
    n.merge!(relationships) unless options[:shallow] == true
    n
  end

  def relationships
    {
      :parents => parents.map{|n|n.to_json(:shallow => true)},
      :children => children.map{|n|n.to_json(:shallow => true)},
      :siblings => siblings.map{|n|n.to_json(:shallow => true)}
    }
  end

  def relationship_uuids
    {
      :child_uuids => child_uuids,
      :parent_uuids => parent_uuids,
      :sibling_uuids => sibling_uuids,
    }
  end

end

# reload!; i = Import::PersonalBrainImport.new; i.import
