# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111024023908) do

  create_table "links", :force => true do |t|
    t.string   "type",       :null => false
    t.string   "node_uuid",  :null => false
    t.string   "uuid",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["node_uuid"], :name => "index_links_on_node_uuid"
  add_index "links", ["uuid"], :name => "index_links_on_uuid", :unique => true

  create_table "nodes", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "description"
    t.string   "uuid",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["title"], :name => "index_nodes_on_title"
  add_index "nodes", ["uuid"], :name => "index_nodes_on_uuid", :unique => true

end
