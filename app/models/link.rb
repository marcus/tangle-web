class Link < ActiveRecord::Base
  include Tangled::Uuid

  attr_protected :uuid
  before_validation :init_uuid, :on => :create
  validates_presence_of :uuid
  validates_uniqueness_of :uuid


end
