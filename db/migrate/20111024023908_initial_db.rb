class InitialDb < ActiveRecord::Migration
  def up

    create_table "nodes", :force => true do |t|
      t.string   "title",                                  :null => false
      t.string   "description"
      t.string   "uuid",     :null => false
      t.timestamps
    end

    create_table "links" do |t|
      t.string     "type", :null => false
      t.string     "node_uuid", :null => false
      t.string     "uuid",   :null => false
      t.timestamps
    end

    add_index :nodes, :title
    add_index :nodes, :uuid, :unique => true

    add_index :links, :uuid, :unique => true
    add_index :links, :node_uuid

  end

  def down
    drop_table "links"
    drop_table "nodes"
  end

end
