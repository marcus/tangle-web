class Node < ActiveRecord::Base
  include Tangled::Uuid

  set_primary_key :uuid
  attr_protected :uuid
  before_validation :init_uuid, :on => :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  def to_json
    {
      :uuid => uuid,
      :title => title,
      :description => description
    }
  end

end
