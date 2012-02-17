class Link < ActiveRecord::Base
  include Tangled::Uuid

  attr_protected :uuid
  before_validation :init_uuid, :on => :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  belongs_to :node, :class_name => "Node", :foreign_key => :relationship_uuid

  belongs_to :parent_node, :class_name => "Node", :foreign_key => :relationship_uuid
  belongs_to :child_node, :class_name => "Node", :foreign_key => :relationship_uuid
  belongs_to :sibling_node, :class_name => "Node", :foreign_key => :relationship_uuid

end
