class AddSyncClientsTable < ActiveRecord::Migration
  def up
    create_table "syncs", :force => true do |t|
      t.string     "endpoint",                                  :null => false # URI or UDID
      t.string     "name"
      t.string     "description"
      t.time       "sync_began"
      t.time       "sync_finished"
      t.boolean    "sync_successful"
      t.string     "sync_error"
      t.timestamps
    end
    add_index :syncs, :endpoint

  end

  def down
    drop_table "syncs"
  end
end
