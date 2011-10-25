# When the app is acting as a client, store successful syncs with the system of record here
class Sync < ActiveRecord::Base
  validates_presence_of :uuid
  validates_uniqueness_of :endpoint

end
