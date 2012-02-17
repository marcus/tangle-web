class Node < ActiveRecord::Base
  include Tangled::Uuid

  set_primary_key :uuid
  attr_protected :uuid
  before_validation :init_uuid, :on => :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  has_many :links, :foreign_key => :node_uuid

  has_many :children_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'child'"
  has_many :parent_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'parent'"
  has_many :sibling_links, :class_name => "Link", :foreign_key => :node_uuid, :conditions => "relationship_type = 'sibling'"

  has_many :relationships, :through => :links, :source => :node

  has_many :children, :through => :children_links, :source => :parent_node
  has_many :parents, :through => :parent_links, :source => :child_node
  has_many :siblings, :through => :sibling_links, :source => :sibling_node

  def to_json
    {
      :uuid => uuid,
      :title => title,
      :description => description
    }.to_json
  end

end
