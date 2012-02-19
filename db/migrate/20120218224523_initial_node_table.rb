class InitialNodeTable < ActiveRecord::Migration
  def up
    create_table "nodes", :id => false, :force => true do |t|
      t.string   "uuid",     :limit => 36, :primary => true
      t.string   "title",    :null => false
      t.string   "description"
      t.string_array "parent_uuids"
      t.string_array "child_uuids"
      t.string_array "sibling_uuids"
      t.timestamps
    end

    add_index :nodes, :title
    add_index :nodes, :uuid, :unique => true
    add_index :nodes, :parent_uuids
    add_index :nodes, :child_uuids
    add_index :nodes, :sibling_uuids
  end

  def down
    drop_table "nodes"
  end
end
