class InitialNodeTable < ActiveRecord::Migration
  def up
    create_table "nodes", :id => false, :force => true do |t|
      t.string   "uuid",     :limit => 36, :primary => true
      t.string   "title",    :null => false
      t.string   "description"
      t.datetime "activated"
      t.timestamps
    end

    create_table "links", :id => false, :force => true do |t|
      t.string "uuid", :limit => 36, :primary => true
      t.string "node_uuid"
      t.string "relationship_uuid"
      t.string "relationship_type"
      t.datetime "activated"
      t.timestamps
    end

    add_index :nodes, :title
    add_index :nodes, :uuid, :unique => true

    add_index :links, :uuid, :unique => true
    add_index :links, :node_uuid
    add_index :links, :relationship_uuid
  end

  def down
    drop_table "nodes"
    drop_table "links"
  end
end
