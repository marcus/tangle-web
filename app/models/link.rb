class Link < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :node, :class_name => "Node", :foreign_key => :relationship_uuid

  belongs_to :parent_node, :class_name => "Node", :foreign_key => :relationship_uuid
  belongs_to :child_node, :class_name => "Node", :foreign_key => :relationship_uuid
  belongs_to :sibling_node, :class_name => "Node", :foreign_key => :relationship_uuid

end
