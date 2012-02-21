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

ActiveRecord::Schema.define(:version => 20120218224523) do

  create_table "links", :id => false, :force => true do |t|
    t.string   "uuid",        :limit => 36
    t.string   "node_a_uuid", :limit => 36
    t.string   "node_b_uuid", :limit => 36
    t.integer  "direction"
    t.datetime "activated"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "links", ["direction"], :name => "index_links_on_direction"
  add_index "links", ["node_a_uuid"], :name => "index_links_on_node_a_uuid"
  add_index "links", ["node_b_uuid"], :name => "index_links_on_node_b_uuid"
  add_index "links", ["uuid"], :name => "index_links_on_uuid", :unique => true

  create_table "nodes", :id => false, :force => true do |t|
    t.string   "uuid",        :limit => 36
    t.string   "title",                     :null => false
    t.string   "description"
    t.datetime "activated"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "nodes", ["title"], :name => "index_nodes_on_title"
  add_index "nodes", ["uuid"], :name => "index_nodes_on_uuid", :unique => true

end
