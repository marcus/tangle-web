class InitialDb < ActiveRecord::Migration
  def up

    create_table "nodes", :force => true do |t|
      t.string   "uuid",     :null => false
      t.string   "title",    :null => false
      t.string   "description"
      t.timestamps

      # t.string   "created_on_client_uuid"
      # t.string   "syncs" # client (URI/UDID), date, conflicts
    end

    add_index :nodes, :title
    add_index :nodes, :uuid, :unique => true

    create_table 'links', :force => true do |t|
      t.string "node_uuid"
      t.string "relationship_uuid"
      t.string "relationship_type"
      t.timestamps

      # t.string   "created_on_client_uuid"
      # t.string   "syncs" # client (URI/UDID), date, conflicts
    end

    add_index :links, :node_uuid
    add_index :links, :relationship_uuid

  end

  def down
    drop_table "nodes"
    drop_table "links"
  end

end
