class InitialNodeTable < ActiveRecord::Migration
  def up
    create_table "nodes", :id => false, :force => true do |t|
      t.string   "uuid",     :limit => 36, :primary => true
      t.text     "title",    :null => false
      t.text     "description"
      t.datetime "activated"
      t.timestamps
    end

    create_table "links", :id => false, :force => true do |t|
      t.string "uuid", :limit => 36, :primary => true
      t.string "node_a_uuid", :limit => 36
      t.string "node_b_uuid", :limit => 36
      t.integer "direction"
      t.datetime "activated"
      t.timestamps
    end

    add_index :nodes, :title
    add_index :nodes, :uuid, :unique => true

    add_index :links, :uuid, :unique => true
    add_index :links, :node_a_uuid
    add_index :links, :node_b_uuid
    add_index :links, :direction
  end

  def down
    drop_table "nodes"
    drop_table "links"
  end
end
