# When the app is acting as a client, store successful syncs with the system of record here
class Sync < ActiveRecord::Base
  validates_presence_of :uuid
  validates_uniqueness_of :endpoint
  before_validation :add_sync_began, :on => :create

  def add_sync_began
    this.sync_began = Time.now
  end

end
